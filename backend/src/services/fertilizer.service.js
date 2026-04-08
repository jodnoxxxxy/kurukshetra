// backend/src/services/fertilizer.service.js

/**
 * FERTILIZER CALCULATOR SERVICE
 * Calculates optimal NPK fertilizer requirements based on crop, soil, and land size
 * 
 * Formula: Fertilizer Required = (Crop requirement - Soil availability) * Safety Factor
 */

class FertilizerCalculatorService {
  constructor() {
    // Crop-specific NPK requirements (kg/hectare)
    this.CROP_REQUIREMENTS = {
      rice: { N: 80, P: 30, K: 15, duration: 120 },
      wheat: { N: 100, P: 50, K: 40, duration: 120 },
      maize: { N: 120, P: 60, K: 30, duration: 100 },
      cotton: { N: 60, P: 30, K: 20, duration: 150 },
      soybean: { N: 40, P: 20, K: 20, duration: 100 },
      groundnut: { N: 20, P: 10, K: 30, duration: 110 },
      sugarcane: { N: 160, P: 40, K: 40, duration: 270 },
      chickpea: { N: 20, P: 40, K: 30, duration: 100 },
      mustard: { N: 60, P: 30, K: 20, duration: 100 },
      tomato: { N: 100, P: 60, K: 80, duration: 100 },
      onion: { N: 100, P: 50, K: 40, duration: 120 },
      potato: { N: 120, P: 60, K: 80, duration: 90 }
    };

    // Fertilizer types and their NPK composition
    this.FERTILIZER_TYPES = {
      // Nitrogenous Fertilizers
      Urea: { N: 46, P: 0, K: 0, cost: 250, unit: 'kg' },
      'Ammonium Nitrate': { N: 34, P: 0, K: 0, cost: 280, unit: 'kg' },
      'Ammonium Sulphate': { N: 21, P: 0, K: 0, cost: 200, unit: 'kg' },
      
      // Phosphatic Fertilizers
      DAP: { N: 18, P: 46, K: 0, cost: 390, unit: 'kg' }, // Di-Ammonium Phosphate
      SSP: { N: 0, P: 16, K: 0, cost: 300, unit: 'kg' }, // Single Super Phosphate
      TSP: { N: 0, P: 46, K: 0, cost: 420, unit: 'kg' }, // Triple Super Phosphate
      
      // Potassic Fertilizers
      MOP: { N: 0, P: 0, K: 60, cost: 350, unit: 'kg' }, // Muriate of Potash
      SOP: { N: 0, P: 0, K: 50, cost: 450, unit: 'kg' }, // Sulphate of Potash
      
      // Complex Fertilizers
      NPK_10_26_26: { N: 10, P: 26, K: 26, cost: 380, unit: 'kg' },
      NPK_12_32_16: { N: 12, P: 32, K: 16, cost: 400, unit: 'kg' },
      NPK_20_20_0: { N: 20, P: 20, K: 0, cost: 320, unit: 'kg' },
      
      // Organic Options
      'Vermicompost': { N: 1.2, P: 0.8, K: 0.8, cost: 150, unit: 'kg' },
      'Farmyard Manure': { N: 0.5, P: 0.2, K: 0.5, cost: 100, unit: 'kg' }
    };

    // Soil nutrient levels (ppm) and interpretation
    this.SOIL_INTERPRETATION = {
      N: { low: 250, medium: 500, high: 1000 },
      P: { low: 20, medium: 40, high: 80 },
      K: { low: 150, medium: 300, high: 600 }
    };
  }

  /**
   * Calculate fertilizer requirement
   * 
   * @param {Object} input - Input parameters
   * @param {string} input.crop - Crop name
   * @param {number} input.landArea - Land area in hectares
   * @param {Object} input.soilNutrients - Current soil NPK levels (ppm)
   * @param {number} input.soilNutrients.N - Nitrogen in ppm
   * @param {number} input.soilNutrients.P - Phosphorus in ppm
   * @param {number} input.soilNutrients.K - Potassium in ppm
   * @returns {Object} - Detailed fertilizer recommendation
   */
  calculateRequirement(input) {
    // Validate input
    this.validateInput(input);

    const crop = input.crop.toLowerCase();
    const cropReq = this.CROP_REQUIREMENTS[crop];
    
    if (!cropReq) {
      throw new Error(`Crop '${input.crop}' not found in database`);
    }

    // Get soil availability (convert ppm to kg/hectare)
    const soilAvailability = this.convertPpmToKgPerHectare(input.soilNutrients);
    
    // Calculate actual requirement
    const requirement = {
      N: Math.max(0, cropReq.N - soilAvailability.N),
      P: Math.max(0, cropReq.P - soilAvailability.P),
      K: Math.max(0, cropReq.K - soilAvailability.K)
    };

    // Apply safety factor (1.2x to account for fixation and losses)
    const safetyFactor = 1.2;
    const finalRequirement = {
      N: Math.round(requirement.N * safetyFactor),
      P: Math.round(requirement.P * safetyFactor),
      K: Math.round(requirement.K * safetyFactor)
    };

    // Calculate for total land area
    const totalRequirement = {
      N: finalRequirement.N * input.landArea,
      P: finalRequirement.P * input.landArea,
      K: finalRequirement.K * input.landArea
    };

    // Get fertilizer recommendations
    const recommendations = this.getFertilizerRecommendations(
      totalRequirement,
      input.budget || 'Medium'
    );

    return {
      success: true,
      crop: input.crop,
      landArea: input.landArea,
      soilAnalysis: {
        N: this.interpretSoilLevel(input.soilNutrients.N, 'N'),
        P: this.interpretSoilLevel(input.soilNutrients.P, 'P'),
        K: this.interpretSoilLevel(input.soilNutrients.K, 'K')
      },
      cropRequirement: {
        perHectare: cropReq,
        totalArea: {
          N: cropReq.N * input.landArea,
          P: cropReq.P * input.landArea,
          K: cropReq.K * input.landArea
        }
      },
      soilAvailability: {
        perHectare: soilAvailability,
        totalArea: {
          N: soilAvailability.N * input.landArea,
          P: soilAvailability.P * input.landArea,
          K: soilAvailability.K * input.landArea
        }
      },
      fertilizer: {
        required: finalRequirement,
        totalRequired: totalRequirement,
        recommendations: recommendations
      },
      timing: this.getFertilizerTiming(crop),
      precautions: [
        'Store fertilizers in dry place away from moisture',
        'Apply in splits to reduce nutrient loss',
        'Spray with adequate water to prevent burning',
        'Wear protective gloves and mask while handling',
        'Keep away from children and livestock'
      ]
    };
  }

  /**
   * Validate input parameters
   */
  validateInput(input) {
    const errors = [];

    if (!input.crop || input.crop.trim() === '') {
      errors.push('Crop name is required');
    }

    if (typeof input.landArea !== 'number' || input.landArea <= 0 || input.landArea > 1000) {
      errors.push('Land area must be between 0.01 and 1000 hectares');
    }

    if (!input.soilNutrients || typeof input.soilNutrients !== 'object') {
      errors.push('Soil nutrients data is required');
    } else {
      if (typeof input.soilNutrients.N !== 'number' || input.soilNutrients.N < 0 || input.soilNutrients.N > 3000) {
        errors.push('Nitrogen level must be 0-3000 ppm');
      }
      if (typeof input.soilNutrients.P !== 'number' || input.soilNutrients.P < 0 || input.soilNutrients.P > 500) {
        errors.push('Phosphorus level must be 0-500 ppm');
      }
      if (typeof input.soilNutrients.K !== 'number' || input.soilNutrients.K < 0 || input.soilNutrients.K > 2000) {
        errors.push('Potassium level must be 0-2000 ppm');
      }
    }

    if (errors.length > 0) {
      throw new Error(`Validation Error: ${errors.join(', ')}`);
    }
  }

  /**
   * Convert soil nutrient levels from ppm to kg/hectare
   * Formula: kg/hectare = ppm * 0.002 (approximate conversion)
   */
  convertPpmToKgPerHectare(soilNutrients) {
    return {
      N: soilNutrients.N * 0.002,
      P: soilNutrients.P * 0.002,
      K: soilNutrients.K * 0.002
    };
  }

  /**
   * Interpret soil nutrient level as low/medium/high
   */
  interpretSoilLevel(ppm, nutrient) {
    const levels = this.SOIL_INTERPRETATION[nutrient];
    if (ppm < levels.low) return 'Low';
    if (ppm < levels.medium) return 'Medium';
    return 'High';
  }

  /**
   * Get fertilizer recommendations with optimal combinations
   */
  getFertilizerRecommendations(requirement, budget) {
    const recommendations = [];

    // Recommendation 1: Chemical fertilizers (budget-friendly)
    recommendations.push({
      name: 'Chemical Fertilizer Mix',
      description: 'Cost-effective mineral fertilizer combination',
      components: [
        { fertilizer: 'Urea', quantity: Math.round(requirement.N / 0.46), cost: Math.round(requirement.N / 0.46 * 250) },
        { fertilizer: 'DAP', quantity: Math.round(requirement.P / 0.46), cost: Math.round(requirement.P / 0.46 * 390) },
        { fertilizer: 'MOP', quantity: Math.round(requirement.K / 0.60), cost: Math.round(requirement.K / 0.60 * 350) }
      ],
      totalCost: Math.round(
        (requirement.N / 0.46 * 250) + 
        (requirement.P / 0.46 * 390) + 
        (requirement.K / 0.60 * 350)
      ),
      applicationType: 'Basal + Split application',
      pros: ['Cost-effective', 'Quick nutrient availability', 'Proven results']
    });

    // Recommendation 2: NPK complex fertilizer
    recommendations.push({
      name: 'NPK Complex Fertilizer',
      description: 'Ready-to-use NPK mixture',
      components: [
        { 
          fertilizer: 'NPK 10-26-26', 
          quantity: Math.round(requirement.N / 0.10), 
          cost: Math.round(requirement.N / 0.10 * 400) 
        }
      ],
      totalCost: Math.round(requirement.N / 0.10 * 400),
      applicationType: 'Basal application + one top-dressing',
      pros: ['Easy application', 'Balanced nutrients', 'Reduced labor cost']
    });

    // Recommendation 3: Organic-inorganic blend (sustainable)
    recommendations.push({
      name: 'Organic-Mineral Blend (Sustainable)',
      description: 'Combination of organic and chemical fertilizers',
      components: [
        { 
          fertilizer: 'Farmyard Manure', 
          quantity: Math.round(requirement.N / 0.005), 
          cost: Math.round(requirement.N / 0.005 * 100) 
        },
        { fertilizer: 'Urea', quantity: Math.round(requirement.N * 0.5 / 0.46), cost: Math.round(requirement.N * 0.5 / 0.46 * 250) },
        { fertilizer: 'SSP', quantity: Math.round(requirement.P / 0.16), cost: Math.round(requirement.P / 0.16 * 300) }
      ],
      totalCost: Math.round(
        (requirement.N / 0.005 * 100) + 
        (requirement.N * 0.5 / 0.46 * 250) + 
        (requirement.P / 0.16 * 300)
      ),
      applicationType: 'Organic as basal, chemicals in splits',
      pros: ['Soil health improvement', 'Environmental friendly', 'Reduced chemical load']
    });

    return recommendations.sort((a, b) => a.totalCost - b.totalCost);
  }

  /**
   * Get fertilizer application timing
   */
  getFertilizerTiming(crop) {
    const timings = {
      rice: [
        { stage: 'Basal (Land Prep)', timing: 'Before transplanting', days: 0, N: 60, P: 100, K: 100 },
        { stage: 'First TopDressing', timing: '20-25 days after transplanting', days: 20, N: 40 },
        { stage: 'Second TopDressing', timing: '45-50 days after transplanting', days: 45, N: '(if needed)' }
      ],
      wheat: [
        { stage: 'Basal', timing: 'Before sowing', days: 0, N: 40, P: 100, K: 100 },
        { stage: 'First TopDressing', timing: '30-35 days after sowing', days: 30, N: 40 },
        { stage: 'Second TopDressing', timing: '60 days after sowing', days: 60, N: 20 }
      ],
      maize: [
        { stage: 'Basal', timing: 'Before sowing', days: 0, N: 60, P: 100, K: 100 },
        { stage: 'First TopDressing', timing: '25-30 days after sowing', days: 25, N: 40 },
        { stage: 'Second TopDressing', timing: 'At silking stage', days: 55, N: 20 }
      ],
      default: [
        { stage: 'Basal', timing: 'Before sowing/planting', days: 0, description: 'Apply full P and K, 50% N' },
        { stage: 'First TopDressing', timing: '30-40 days after sowing', days: 35, description: 'Apply 25% N' },
        { stage: 'Second TopDressing', timing: '60-70 days after sowing', days: 65, description: 'Apply remaining 25% N if needed' }
      ]
    };

    return timings[crop] || timings.default;
  }

  /**
   * Get detailed nutrient information
   */
  getNutrientInfo(nutrient) {
    const info = {
      N: {
        name: 'Nitrogen',
        role: 'Promotes vegetative growth, leaf and stem development',
        deficiency: 'Yellow leaves, stunted growth, poor yield',
        toxicity: 'Excessive vine growth, delayed maturity, disease susceptibility',
        bestSources: ['Urea', 'Ammonium Nitrate', 'Farmyard Manure']
      },
      P: {
        name: 'Phosphorus',
        role: 'Root development, flowering, seed formation, energy transfer',
        deficiency: 'Purple discoloration, poor root growth, delayed flowering',
        toxicity: 'Rare, but causes zinc deficiency',
        bestSources: ['DAP', 'TSP', 'SSP', 'Bone Meal']
      },
      K: {
        name: 'Potassium',
        role: 'Fruit quality, disease resistance, water regulation',
        deficiency: 'Marginal scorch, weak stems, poor fruit quality',
        toxicity: 'Reduced calcium and magnesium absorption',
        bestSources: ['MOP', 'SOP', 'Wood Ash']
      }
    };

    return info[nutrient] || {};
  }
}

module.exports = new FertilizerCalculatorService();
