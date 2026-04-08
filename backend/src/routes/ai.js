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

// POST /api/v1/ai/crop-recommendation
router.post('/crop-recommendation', async (req, res) => {
  try {
    const { error } = cropRecommendationSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        status: 'error',
        message: error.details[0].message,
      });
    }

    const { soilType, waterAvailability, temp, season } = req.body;

    // Logic for recommendation (can be replaced with AI service call)
    const recommendations = generateCropRecommendations(soilType, waterAvailability, temp, season);

    res.status(200).json({
      status: 'success',
      data: recommendations,
    });
  } catch (error) {
    logger.error('Crop recommendation error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to generate crop recommendations',
    });
  }
});

function generateCropRecommendations(soilType, water, temp, season) {
  const allCrops = [
    {
      name: 'Rice',
      reason: 'Suitable for high water availability and alluvial soil.',
      description: 'Rice is the most important staple food crop of India.',
      imageUrl: 'https://images.unsplash.com/photo-1536633100227-2300bcfd01e6?q=80&w=400&auto=format&fit=crop',
      steps: getGeneralSteps('Rice'),
    },
    {
      name: 'Wheat',
      reason: 'Perfect for Rabi season and moderate temperature.',
      description: 'Wheat is the second most important cereal crop in India.',
      imageUrl: 'https://images.unsplash.com/photo-1501438901235-5b4d7938384b?q=80&w=400&auto=format&fit=crop',
      steps: getGeneralSteps('Wheat'),
    },
    {
      name: 'Cotton',
      reason: 'Grows well in black soil with high temperature.',
      description: 'Cotton is one of the most important fiber and cash crops of India.',
      imageUrl: 'https://images.unsplash.com/photo-1594904351111-a072f80b1a71?q=80&w=400&auto=format&fit=crop',
      steps: getGeneralSteps('Cotton'),
    },
    {
      name: 'Maize',
      reason: 'Versatile crop suitable for various soil types.',
      description: 'Maize is known as the queen of cereals.',
      imageUrl: 'https://images.unsplash.com/photo-1551730459-92db2a308d6a?q=80&w=400&auto=format&fit=crop',
      steps: getGeneralSteps('Maize'),
    },
  ];

  let recommended = [];
  if (soilType.toLowerCase().includes('black')) recommended.push(allCrops[2]);
  if (water === 'High') recommended.push(allCrops[0]);
  if (season === 'Rabi') recommended.push(allCrops[1]);

  if (recommended.length < 3) {
    for (const crop of allCrops) {
      if (!recommended.find(r => r.name === crop.name)) {
        recommended.push(crop);
      }
      if (recommended.length === 3) break;
    }
  }

  return recommended.slice(0, 3);
}

function getGeneralSteps(cropName) {
  return [
    { title: 'Land Preparation', description: `Plough the field for ${cropName}.`, durationDays: 7, icon: 'agriculture' },
    { title: 'Sowing', description: `Sow ${cropName} seeds properly.`, durationDays: 2, icon: 'grain' },
    { title: 'Irrigation', description: 'Water as needed.', durationDays: 90, icon: 'waves' },
    { title: 'Harvesting', description: `Harvest ${cropName} when ripe.`, durationDays: 10, icon: 'content_cut' },
  ];
}

module.exports = router;
