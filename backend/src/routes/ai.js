const express = require('express');
const router = express.Router();
const Joi = require('joi');
const axios = require('axios');

const config = require('../config');
const { prisma } = require('../config/database');
const logger = require('../utils/logger');

// Validation schema for soil analysis
const soilAnalysisSchema = Joi.object({
  n: Joi.number().min(0).max(500).required(),
  p: Joi.number().min(0).max(500).required(),
  k: Joi.number().min(0).max(500).required(),
  ph: Joi.number().min(0).max(14).required(),
  soilType: Joi.string().valid('Loamy', 'Clay', 'Sandy', 'Silt', 'Peaty', 'Saline').required(),
  farmId: Joi.string().uuid().optional(),
});

// Validation schema for crop recommendation
const cropRecommendationSchema = Joi.object({
  soilType: Joi.string().required(),
  waterAvailability: Joi.string().valid('Low', 'Medium', 'High').required(),
  temp: Joi.number().required(),
  season: Joi.string().valid('Kharif', 'Rabi', 'Summer').required(),
});

// POST /api/v1/ai/soil-analysis
router.post('/soil-analysis', async (req, res) => {
  try {
    // Validate input
    const { error } = soilAnalysisSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        status: 'error',
        message: error.details[0].message,
      });
    }

    const { n, p, k, ph, soilType, farmId } = req.body;

    // Call AI service for soil analysis
    let aiResponse;
    try {
      const aiServiceUrl = config.SOIL_ANALYSIS_URL || 'http://localhost:8001';
      const response = await axios.post(`${aiServiceUrl}/analyze-soil`, {
        nitrogen_ppm: n,
        phosphorus_ppm: p,
        potassium_ppm: k,
        ph_level: ph,
        soil_type: soilType,
      }, {
        timeout: config.AI_TIMEOUT_MS || 30000,
      });
      aiResponse = response.data;
    } catch (aiError) {
      logger.error('AI service error:', aiError.message);
      
      // Fallback to basic calculation if AI service is unavailable
      aiResponse = {
        health_score: calculateBasicHealthScore(n, p, k, ph),
        recommendations: generateBasicRecommendations(n, p, k, ph, soilType),
        deficiencies: identifyDeficiencies(n, p, k, ph),
      };
    }

    // Store analysis in database if farmId is provided
    let soilAnalysisRecord = null;
    if (farmId) {
      try {
        soilAnalysisRecord = await prisma.soilAnalysis.create({
          data: {
            farmId,
            nitrogenPpm: n,
            phosphorusPpm: p,
            potassiumPpm: k,
            phLevel: ph,
            healthScore: aiResponse.health_score,
            recommendations: aiResponse.recommendations,
          },
        });
      } catch (dbError) {
        logger.error('Failed to save soil analysis:', dbError.message);
        // Continue even if database save fails
      }
    }

    res.status(200).json({
      status: 'success',
      data: {
        analysis: aiResponse,
        record: soilAnalysisRecord,
      },
    });

  } catch (error) {
    logger.error('Soil analysis error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to analyze soil data',
    });
  }
});

// Helper function for basic health score calculation
function calculateBasicHealthScore(n, p, k, ph) {
  let score = 0;
  
  // NPK scoring (ideal ranges vary by crop, using general ranges)
  const nScore = Math.min(100, (n / 200) * 100);
  const pScore = Math.min(100, (p / 80) * 100);
  const kScore = Math.min(100, (k / 300) * 100);
  
  // pH scoring (ideal range 6.0-7.5)
  let phScore = 100;
  if (ph < 6.0 || ph > 7.5) {
    phScore = Math.max(0, 100 - Math.abs(ph - 6.75) * 20);
  }
  
  score = (nScore + pScore + kScore + phScore) / 4;
  return Math.round(score * 100) / 100;
}

// Helper function for basic recommendations
function generateBasicRecommendations(n, p, k, ph, soilType) {
  const recommendations = [];
  
  if (n < 150) {
    recommendations.push({
      type: 'fertilizer',
      nutrient: 'Nitrogen',
      suggestion: 'Apply nitrogen-rich fertilizer (urea, ammonium nitrate)',
      amount: '50-100 kg/ha depending on crop',
    });
  }
  
  if (p < 40) {
    recommendations.push({
      type: 'fertilizer',
      nutrient: 'Phosphorus',
      suggestion: 'Apply phosphorus-rich fertilizer (DAP, SSP)',
      amount: '40-60 kg/ha depending on crop',
    });
  }
  
  if (k < 200) {
    recommendations.push({
      type: 'fertilizer',
      nutrient: 'Potassium',
      suggestion: 'Apply potassium-rich fertilizer (MOP, SOP)',
      amount: '40-80 kg/ha depending on crop',
    });
  }
  
  if (ph < 6.0) {
    recommendations.push({
      type: 'soil_amendment',
      nutrient: 'pH',
      suggestion: 'Apply lime to increase pH',
      amount: '2-4 tons/ha depending on current pH',
    });
  } else if (ph > 7.5) {
    recommendations.push({
      type: 'soil_amendment',
      nutrient: 'pH',
      suggestion: 'Apply elemental sulfur or gypsum to decrease pH',
      amount: '500-1000 kg/ha depending on current pH',
    });
  }
  
  // Soil type specific recommendations
  if (soilType === 'Sandy') {
    recommendations.push({
      type: 'soil_management',
      nutrient: 'Organic Matter',
      suggestion: 'Add organic compost to improve water retention',
      amount: '5-10 tons/ha annually',
    });
  }
  
  return recommendations;
}

// Helper function to identify deficiencies
function identifyDeficiencies(n, p, k, ph) {
  const deficiencies = [];
  
  if (n < 150) deficiencies.push('Nitrogen');
  if (p < 40) deficiencies.push('Phosphorus');
  if (k < 200) deficiencies.push('Potassium');
  if (ph < 6.0) deficiencies.push('Acidity');
  if (ph > 7.5) deficiencies.push('Alkalinity');
  
  return deficiencies;
}

// COMPREHENSIVE CROP DATABASE with season, temperature, water requirements 
const CROP_DATABASE = [
  // Kharif (Monsoon) Crops
  { name: 'Rice', season: 'Kharif', tempMin: 15, tempMax: 35, waterNeeds: 'High', soilType: ['Loamy', 'Alluvial', 'Clay'], suitability: { Kharif: 95, Rabi: 10, Summer: 5 }, reason: 'Ideal for high water availability and monsoon season' },
  { name: 'Maize', season: 'Kharif', tempMin: 20, tempMax: 30, waterNeeds: 'Medium', soilType: ['Loamy', 'Sandy Loam', 'Black'], suitability: { Kharif: 90, Rabi: 40, Summer: 30 }, reason: 'Versatile, grows well in various soils' },
  { name: 'Cotton', season: 'Kharif', tempMin: 25, tempMax: 40, waterNeeds: 'Low', soilType: ['Black', 'Loamy'], suitability: { Kharif: 85, Rabi: 20, Summer: 60 }, reason: 'Thrives in high temperature and black soil' },
  { name: 'Soybean', season: 'Kharif', tempMin: 20, tempMax: 35, waterNeeds: 'Medium', soilType: ['Black', 'Loamy', 'Sandy Loam'], suitability: { Kharif: 90, Rabi: 30, Summer: 10 }, reason: 'Good protein crop, suitable for black soil' },
  { name: 'Sugarcane', season: 'Kharif', tempMin: 20, tempMax: 30, waterNeeds: 'High', soilType: ['Loamy', 'Alluvial', 'Sandy Loam'], suitability: { Kharif: 80, Rabi: 10, Summer: 50 }, reason: 'Needs regular water and warm climate' },
  
  // Rabi (Winter) Crops
  { name: 'Wheat', season: 'Rabi', tempMin: 10, tempMax: 25, waterNeeds: 'Low', soilType: ['Loamy', 'Clay Loam', 'Sandy Loam'], suitability: { Kharif: 20, Rabi: 95, Summer: 10 }, reason: 'Perfect for winter season and moderate temperature' },
  { name: 'Chickpea', season: 'Rabi', tempMin: 10, tempMax: 25, waterNeeds: 'Low', soilType: ['Black', 'Loamy', 'Clay'], suitability: { Kharif: 10, Rabi: 90, Summer: 5 }, reason: 'Nitrogen-fixing, good for soil health' },
  { name: 'Mustard', season: 'Rabi', tempMin: 10, tempMax: 25, waterNeeds: 'Low', soilType: ['Loamy', 'Clay Loam', 'Sandy'], suitability: { Kharif: 15, Rabi: 85, Summer: 10 }, reason: 'Oil crop, suitable for winter' },
  { name: 'Barley', season: 'Rabi', tempMin: 5, tempMax: 25, waterNeeds: 'Low', soilType: ['Loamy', 'Sandy Loam', 'Clay'], suitability: { Kharif: 10, Rabi: 90, Summer: 5 }, reason: 'Tolerates cold better than wheat' },
  { name: 'Lentil', season: 'Rabi', tempMin: 10, tempMax: 25, waterNeeds: 'Low', soilType: ['Well-drained', 'Loamy', 'Sandy'], suitability: { Kharif: 10, Rabi: 85, Summer: 5 }, reason: 'Protein-rich legume for winter' },
  
  // Summer Crops
  { name: 'Groundnut', season: 'Summer', tempMin: 25, tempMax: 35, waterNeeds: 'Low', soilType: ['Sandy Loam', 'Loamy'], suitability: { Kharif: 30, Rabi: 10, Summer: 90 }, reason: 'Heat and drought tolerant oil crop' },
  { name: 'Sesame', season: 'Summer', tempMin: 25, tempMax: 35, waterNeeds: 'Low', soilType: ['Well-drained', 'Sandy Loam'], suitability: { Kharif: 30, Rabi: 10, Summer: 85 }, reason: 'Thrives in heat and dry conditions' },
  { name: 'Vegetables (Summer)', season: 'Summer', tempMin: 20, tempMax: 35, waterNeeds: 'Medium', soilType: ['Loamy', 'Sandy Loam'], suitability: { Kharif: 40, Rabi: 20, Summer: 80 }, reason: 'Tomato, Cucumber, Brinjal - market demand' },
  
  // Year-round
  { name: 'Sugarcane', season: 'All', tempMin: 20, tempMax: 30, waterNeeds: 'High', soilType: ['Loamy', 'Alluvial'], suitability: { Kharif: 80, Rabi: 30, Summer: 50 }, reason: 'Can be planted anytime, long duration' },
  { name: 'Fruits (Mango)', season: 'All', tempMin: 15, tempMax: 40, waterNeeds: 'Medium', soilType: ['Well-drained', 'Loamy'], suitability: { Kharif: 70, Rabi: 60, Summer: 75 }, reason: 'Perennial, good for market value' },
  { name: 'Coconut', season: 'All', tempMin: 24, tempMax: 30, waterNeeds: 'High', soilType: ['Sandy', 'Sandy Loam', 'Alluvial'], suitability: { Kharif: 70, Rabi: 70, Summer: 70 }, reason: 'Perennial, high value crop' },
];

// POST /api/v1/ai/crop-recommendation
router.post('/crop-recommendation', async (req, res) => {
  try {
    const { error } = cropRecommendationSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        status: 'error',
        message: error.details[0].message,
        code: 'VALIDATION_ERROR'
      });
    }

    const { soilType, waterAvailability, temp, season } = req.body;

    // INPUT VALIDATION & EDGE CASE HANDLING
    if (!soilType || !season || temp === undefined || temp === null) {
      return res.status(400).json({
        status: 'error',
        message: 'Missing required parameters: soilType, waterAvailability, temp, season',
        code: 'MISSING_PARAMETERS'
      });
    }

    // Validate temperature range
    const temperature = parseFloat(temp);
    if (isNaN(temperature) || temperature < -10 || temperature > 50) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid temperature value. Must be between -10°C and 50°C',
        code: 'INVALID_TEMPERATURE'
      });
    }

    // Validate season
    if (!['Kharif', 'Rabi', 'Summer'].includes(season)) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid season. Must be Kharif, Rabi, or Summer',
        code: 'INVALID_SEASON'
      });
    }

    // Generate smart recommendations
    const recommendations = generateSmartCropRecommendations(soilType, waterAvailability, temperature, season);

    res.status(200).json({
      status: 'success',
      data: recommendations,
      metadata: {
        season,
        temperature,
        soilType,
        waterAvailability,
        generatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Crop recommendation error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to generate crop recommendations',
      code: 'INTERNAL_ERROR'
    });
  }
});

// IMPROVED SMART CROP RECOMMENDATION ENGINE
function generateSmartCropRecommendations(soilType, waterAvailability, temperature, season) {
  let candidates = [];

  // STEP 1: Filter by season suitability
  const seasonalCrops = CROP_DATABASE.filter(crop => {
    const suitabilityForSeason = crop.suitability[season] || 0;
    return suitabilityForSeason >= 60; // At least moderately suitable for season
  });

  // STEP 2: Filter by temperature range
  const temperatureSuitableCrops = seasonalCrops.filter(crop => {
    return temperature >= crop.tempMin && temperature <= crop.tempMax;
  });

  // STEP 3: Calculate suitability score for each crop
  const scoredCrops = temperatureSuitableCrops.map(crop => {
    let score = 0;

    // Season suitability (40% weight)
    const seasonScore = crop.suitability[season] || 0;
    score += seasonScore * 0.40;

    // Temperature fit (30% weight) - closer to mid-range is better
    const tempMid = (crop.tempMin + crop.tempMax) / 2;
    const tempDeviation = Math.abs(temperature - tempMid);
    const tempRange = crop.tempMax - crop.tempMin;
    const tempSuitability = Math.max(0, 100 - (tempDeviation / tempRange) * 100);
    score += tempSuitability * 0.30;

    // Soil type match (20% weight)
    const soilMatch = crop.soilType.some(s => 
      soilType.toLowerCase().includes(s.toLowerCase()) || s.toLowerCase().includes(soilType.toLowerCase())
    );
    score += soilMatch ? 20 : 5;

    // Water availability match (10% weight)
    let waterScore = 0;
    if (waterAvailability === 'High' && crop.waterNeeds === 'High') waterScore = 10;
    else if (waterAvailability === 'Medium' && (crop.waterNeeds === 'Medium' || crop.waterNeeds === 'Low')) waterScore = 10;
    else if (waterAvailability === 'Low' && crop.waterNeeds === 'Low') waterScore = 10;
    else waterScore = 3; // Partial compatibility
    score += waterScore;

    return {
      ...crop,
      suitabilityScore: Math.round(score),
      matchDetails: {
        seasonMatch: seasonScore,
        temperatureMatch: Math.round(tempSuitability),
        soilMatch: soilMatch,
        waterMatch: waterScore
      }
    };
  });

  // STEP 4: Sort by score and return top recommendations
  candidates = scoredCrops
    .sort((a, b) => b.suitabilityScore - a.suitabilityScore)
    .slice(0, 5) // Return top 5 candidates
    .map(crop => ({
      name: crop.name,
      suitability: `${crop.suitabilityScore}%`,
      reason: crop.reason,
      description: `Suitable for ${season} season with ${temperature}°C temperature`,
      tempRange: `${crop.tempMin}-${crop.tempMax}°C`,
      waterRequirement: crop.waterNeeds,
      soilSuitability: crop.soilType.join(', '),
      steps: getDetailedSteps(crop.name, season),
      matchScore: {
        season: crop.matchDetails.seasonMatch,
        temperature: crop.matchDetails.temperatureMatch,
        soil: crop.matchDetails.soilMatch ? 'Perfect' : 'Good',
        water: crop.matchDetails.waterMatch > 5 ? 'Good' : 'Okay'
      }
    }));

  // EDGE CASE: If no crops match perfectly
  if (candidates.length === 0) {
    return [{
      name: 'None',
      suitability: '0%',
      reason: 'Current conditions are not suitable for major crops. Consider:',
      description: '1. Wait for better weather conditions\n2. Prepare soil for next season\n3. Grow green manure/cover crops',
      steps: [{
        title: 'Soil Preparation',
        description: 'Improve soil fertility with organic matter',
        durationDays: 30,
        icon: 'agriculture'
      }]
    }];
  }

  return candidates;
}

// Enhanced crop-specific steps
function getDetailedSteps(cropName, season) {
  const stepsMap = {
    'Rice': [
      { title: 'Land Preparation', description: 'Puddling and leveling the field for Rice', durationDays: 10, icon: 'agriculture' },
      { title: 'Seedling', description: 'Prepare nursery beds and sow seeds', durationDays: 20, icon: 'grain' },
      { title: 'Transplanting', description: 'Transplant seedlings in prepared field', durationDays: 5, icon: 'agriculture' },
      { title: 'Maintenance', description: 'Regular weeding and water management', durationDays: 90, icon: 'waves' },
      { title: 'Harvesting', description: 'Harvest when grains have 20% moisture', durationDays: 15, icon: 'content_cut' }
    ],
    'Wheat': [
      { title: 'Field Preparation', description: 'Plow and prepare seedbed for Wheat', durationDays: 7, icon: 'agriculture' },
      { title: 'Sowing', description: 'Sow wheat seeds at 100 kg/ha', durationDays: 3, icon: 'grain' },
      { title: 'Fertilization', description: 'Apply nitrogen fertilizer as per soil test', durationDays: 30, icon: 'chemistry' },
      { title: 'Irrigation', description: 'Give 3-4 irrigations based on weather', durationDays: 120, icon: 'waves' },
      { title: 'Harvesting', description: 'Harvest when plants turn golden brown', durationDays: 10, icon: 'content_cut' }
    ],
    'Cotton': [
      { title: 'Soil Preparation', description: 'Deep plowing and soil testing essential', durationDays: 14, icon: 'agriculture' },
      { title: 'Sowing', description: 'Sow cotton seeds at 18-20 kg/ha', durationDays: 5, icon: 'grain' },
      { title: 'Pest Management', description: 'Monitor for pests regularly', durationDays: 120, icon: 'bug_report' },
      { title: 'Picking', description: 'Manual picking of cotton bolls', durationDays: 30, icon: 'content_cut' }
    ],
    'Maize': [
      { title: 'Field Preparation', description: 'Plow and prepare ridges for Maize', durationDays: 7, icon: 'agriculture' },
      { title: 'Sowing', description: 'Sow hybrid seeds at 20 kg/ha', durationDays: 3, icon: 'grain' },
      { title: 'Thinning', description: 'Thin seedlings to 60x20 cm spacing', durationDays: 20, icon: 'agriculture' },
      { title: 'Maintenance', description: 'Regular weeding and earthing up', durationDays: 80, icon: 'waves' },
      { title: 'Harvesting', description: 'Harvest when cobs are hard and dry', durationDays: 15, icon: 'content_cut' }
    ],
    'Groundnut': [
      { title: 'Soil Preparation', description: 'Well-drained sandy soil preferred', durationDays: 10, icon: 'agriculture' },
      { title: 'Sowing', description: 'Sow certified seeds at 90-110 kg/ha', durationDays: 5, icon: 'grain' },
      { title: 'Maintenance', description: 'Weeding and mulching essential', durationDays: 100, icon: 'waves' },
      { title: 'Harvesting', description: 'Uproot when pods are mature', durationDays: 10, icon: 'content_cut' }
    ]
  };

  return stepsMap[cropName] || [
    { title: 'Land Preparation', description: `Prepare field for ${cropName}`, durationDays: 7, icon: 'agriculture' },
    { title: 'Sowing', description: `Sow ${cropName} seeds properly`, durationDays: 3, icon: 'grain' },
    { title: 'Maintenance', description: 'Monitor crop growth and health', durationDays: 90, icon: 'waves' },
    { title: 'Harvesting', description: `Harvest ${cropName} when ready`, durationDays: 10, icon: 'content_cut' }
  ];
}

module.exports = router;
