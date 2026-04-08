// backend/src/services/soil.service.js

/**
 * SOIL HEALTH CARD SERVICE
 * Analyzes soil parameters and generates health scores with improvement suggestions
 * 
 * Parameters: pH, NPK levels, Organic Matter, EC, Zinc, Iron, Copper, Manganese
 */

class SoilHealthService {
  constructor() {
    // Soil parameter standards for different crops
    this.SOIL_STANDARDS = {
      rice: {
        pH: { min: 6.0, max: 7.0, optimal: 6.5 },
        N: { min: 200, max: 300, optimal: 250 },
        P: { min: 15, max: 30, optimal: 25 },
        K: { min: 150, max: 300, optimal: 200 },
        OM: { min: 1.5, max: 3.0, optimal: 2.0 },
        EC: { min: 0, max: 2, optimal: 0.5 }
      },
      wheat: {
        pH: { min: 6.5, max: 7.5, optimal: 7.0 },
        N: { min: 250, max: 400, optimal: 300 },
        P: { min: 20, max: 40, optimal: 30 },
        K: { min: 200, max: 350, optimal: 250 },
        OM: { min: 2.0, max: 3.5, optimal: 2.5 },
        EC: { min: 0, max: 2, optimal: 0.5 }
      },
      maize: {
        pH: { min: 6.0, max: 7.5, optimal: 6.8 },
        N: { min: 200, max: 400, optimal: 300 },
        P: { min: 15, max: 35, optimal: 25 },
        K: { min: 180, max: 350, optimal: 250 },
        OM: { min: 1.5, max: 3.0, optimal: 2.2 },
        EC: { min: 0, max: 2, optimal: 0.5 }
      },
      cotton: {
        pH: { min: 6.5, max: 8.0, optimal: 7.0 },
        N: { min: 200, max: 300, optimal: 250 },
        P: { min: 20, max: 40, optimal: 30 },
        K: { min: 200, max: 400, optimal: 300 },
        OM: { min: 1.5, max: 2.5, optimal: 2.0 },
        EC: { min: 0, max: 2, optimal: 0.5 }
      },
      sugarcane: {
        pH: { min: 6.0, max: 8.0, optimal: 7.0 },
        N: { min: 300, max: 500, optimal: 400 },
        P: { min: 20, max: 40, optimal: 30 },
        K: { min: 200, max: 400, optimal: 300 },
        OM: { min: 2.0, max: 4.0, optimal: 3.0 },
        EC: { min: 0, max: 2, optimal: 0.5 }
      }
    };

    // Micronutrient standards (ppm)
    this.MICRONUTRIENT_STANDARDS = {
      Zn: { low: 0.5, medium: 1.0, high: 2.0 },
      Fe: { low: 2.0, medium: 4.0, high: 10.0 },
      Cu: { low: 0.2, medium: 0.5, high: 1.0 },
      Mn: { low: 1.0, medium: 2.0, high: 5.0 },
      B: { low: 0.3, medium: 0.5, high: 1.0 },
      Mo: { low: 0.1, medium: 0.2, high: 0.5 }
    };
  }

  /**
   * Generate comprehensive soil health card
   * 
   * @param {Object} input - Soil test parameters
   * @param {number} input.pH - Soil pH (0-14)
   * @param {number} input.nitrogen - N level (ppm)
   * @param {number} input.phosphorus - P level (ppm)
   * @param {number} input.potassium - K level (ppm)
   * @param {number} input.organicMatter - OM percentage
   * @param {number} input.ec - Electrical Conductivity (dS/m)
   * @param {Object} input.micronutrients - Micronutrients (optional)
   * @param {string} input.crop - Target crop name
   * @returns {Object} - Soil health report
   */
  generateSoilHealthCard(input) {
    this.validateInput(input);

    const crop = input.crop.toLowerCase();
    const standards = this.SOIL_STANDARDS[crop] || this.getDefaultStandards();

    // Analyze each macro nutrient
    const macroAnalysis = this.analyzeMacroNutrients(input, standards);
    const microAnalysis = input.micronutrients ? this.analyzeMicroNutrients(input.micronutrients) : null;

    // Calculate overall health score
    const healthScore = this.calculateHealthScore(macroAnalysis, microAnalysis);

    // Generate improvement suggestions
    const improvements = this.generateImprovements(input, macroAnalysis, standards);

    // Generate detailed report
    return {
      success: true,
      crop: input.crop,
      testDate: new Date().toISOString().split('T')[0],
      healthScore: {
        overall: healthScore.overall,
        grade: this.getGrade(healthScore.overall),
        status: this.getStatus(healthScore.overall),
        color: this.getColor(healthScore.overall)
      },
      macroNutrientAnalysis: macroAnalysis,
      microNutrientAnalysis: microAnalysis,
      improvements: improvements,
      actionPlan: this.generateActionPlan(improvements),
      timeline: this.generateTimeline(improvements),
      costEstimate: this.estimateCost(improvements),
      warnings: this.generateWarnings(input, standards),
      certifications: this.checkCertifications(input),
      nextTestDate: this.getNextTestDate(),
      complianceReport: this.generateComplianceReport(input, standards, crop)
    };
  }

  /**
   * Validate soil test parameters
   */
  validateInput(input) {
    const errors = [];

    if (typeof input.pH !== 'number' || input.pH < 0 || input.pH > 14) {
      errors.push('pH must be between 0-14');
    }

    if (typeof input.nitrogen !== 'number' || input.nitrogen < 0 || input.nitrogen > 3000) {
      errors.push('Nitrogen must be 0-3000 ppm');
    }

    if (typeof input.phosphorus !== 'number' || input.phosphorus < 0 || input.phosphorus > 500) {
      errors.push('Phosphorus must be 0-500 ppm');
    }

    if (typeof input.potassium !== 'number' || input.potassium < 0 || input.potassium > 2000) {
      errors.push('Potassium must be 0-2000 ppm');
    }

    if (typeof input.organicMatter !== 'number' || input.organicMatter < 0 || input.organicMatter > 10) {
      errors.push('Organic Matter must be 0-10%');
    }

    if (typeof input.ec !== 'number' || input.ec < 0 || input.ec > 10) {
      errors.push('EC must be 0-10 dS/m');
    }

    if (!input.crop || input.crop.trim() === '') {
      errors.push('Crop name is required');
    }

    if (errors.length > 0) {
      throw new Error(`Validation Error: ${errors.join(', ')}`);
    }
  }

  /**
   * Analyze macronutrient levels
   */
  analyzeMacroNutrients(input, standards) {
    return {
      pH: {
        value: input.pH,
        standard: standards.pH,
        status: this.getParameterStatus(input.pH, standards.pH),
        range: this.getStatusRange(input.pH, standards.pH),
        recommendation: this.getpHRecommendation(input.pH, standards.pH.optimal),
        optimality: this.calculateOptimality(input.pH, standards.pH)
      },
      nitrogen: {
        value: input.nitrogen,
        standard: standards.N,
        status: this.getParameterStatus(input.nitrogen, standards.N),
        range: this.getStatusRange(input.nitrogen, standards.N),
        recommendation: this.getNutrientRecommendation('Nitrogen', input.nitrogen, standards.N),
        optimality: this.calculateOptimality(input.nitrogen, standards.N)
      },
      phosphorus: {
        value: input.phosphorus,
        standard: standards.P,
        status: this.getParameterStatus(input.phosphorus, standards.P),
        range: this.getStatusRange(input.phosphorus, standards.P),
        recommendation: this.getNutrientRecommendation('Phosphorus', input.phosphorus, standards.P),
        optimality: this.calculateOptimality(input.phosphorus, standards.P)
      },
      potassium: {
        value: input.potassium,
        standard: standards.K,
        status: this.getParameterStatus(input.potassium, standards.K),
        range: this.getStatusRange(input.potassium, standards.K),
        recommendation: this.getNutrientRecommendation('Potassium', input.potassium, standards.K),
        optimality: this.calculateOptimality(input.potassium, standards.K)
      },
      organicMatter: {
        value: input.organicMatter,
        standard: standards.OM,
        status: this.getParameterStatus(input.organicMatter, standards.OM, true),
        range: this.getStatusRange(input.organicMatter, standards.OM),
        recommendation: this.getOrganicMatterRecommendation(input.organicMatter, standards.OM.optimal),
        optimality: this.calculateOptimality(input.organicMatter, standards.OM)
      },
      ec: {
        value: input.ec,
        standard: standards.EC,
        status: this.getParameterStatus(input.ec, standards.EC),
        range: this.getStatusRange(input.ec, standards.EC),
        recommendation: this.getECRecommendation(input.ec),
        optimality: this.calculateOptimality(input.ec, standards.EC)
      }
    };
  }

  /**
   * Analyze micronutrients
   */
  analyzeMicroNutrients(micronutrients) {
    const analysis = {};

    Object.entries(micronutrients).forEach(([nutrient, value]) => {
      const standards = this.MICRONUTRIENT_STANDARDS[nutrient];
      if (standards) {
        analysis[nutrient] = {
          value: value,
          standard: standards,
          status: value < standards.low ? 'Deficient' : value < standards.medium ? 'Low' : 'Sufficient',
          recommendation: this.getMicroNutrientRecommendation(nutrient, value, standards)
        };
      }
    });

    return analysis;
  }

  /**
   * Determine parameter status
   */
  getParameterStatus(value, standard, inverse = false) {
    const { min, max } = standard;

    if (value < min) {
      return inverse ? 'High' : 'Low/Deficient';
    }
    if (value > max) {
      return inverse ? 'Low' : 'High/Excessive';
    }
    return 'Optimal';
  }

  /**
   * Get optimality percentage
   */
  calculateOptimality(value, standard) {
    const { min, max, optimal } = standard;
    const range = max - min;

    if (value < min) {
      const distance = min - value;
      return Math.max(0, 100 - (distance / range) * 50);
    }
    if (value > max) {
      const distance = value - max;
      return Math.max(0, 100 - (distance / range) * 50);
    }

    // Closer to optimal
    const distance = Math.abs(value - optimal);
    return 100 - (distance / range) * 30;
  }

  /**
   * Generate pH recommendation
   */
  getpHRecommendation(current, optimal) {
    if (Math.abs(current - optimal) <= 0.5) {
      return 'pH is optimal for crop growth';
    }
    if (current < optimal) {
      return `Apply lime (CaCO3) 500-1000 kg/hectare to increase pH`;
    }
    return `Apply sulfur or gypsum 250-500 kg/hectare to decrease pH`;
  }

  /**
   * Generate nutrient recommendation
   */
  getNutrientRecommendation(nutrient, current, standard) {
    const { min, max } = standard;

    if (current < min) {
      return `${nutrient} is deficient. Apply suitable fertilizer to achieve optimal level`;
    }
    if (current > max) {
      return `${nutrient} is excessive. Avoid additional application, use other crops`;
    }
    return `${nutrient} is at optimal level. Maintain current fertilization practice`;
  }

  /**
   * Generate organic matter recommendation
   */
  getOrganicMatterRecommendation(current, optimal) {
    if (current < optimal * 0.7) {
      return 'Add 5-10 tons farmyard manure/hectare annually';
    }
    if (current < optimal) {
      return 'Add 3-5 tons farmyard manure/hectare annually';
    }
    return 'Organic matter is at optimal level. Continue current practice';
  }

  /**
   * Generate EC recommendation
   */
  getECRecommendation(ec) {
    if (ec > 2) {
      return 'Soil salinity is high. Use salt tolerant varieties, apply gypsum';
    }
    return 'EC is normal. No salinity concerns';
  }

  /**
   * Generate micronutrient recommendation
   */
  getMicroNutrientRecommendation(nutrient, value, standard) {
    if (value < standard.low) {
      return `${nutrient} is deficient. Apply ${nutrient} sulfate or chelate`;
    }
    if (value < standard.medium) {
      return `${nutrient} is low. Monitor and apply if symptoms appear`;
    }
    return `${nutrient} is adequate`;
  }

  /**
   * Calculate overall health score (0-100)
   */
  calculateHealthScore(macroAnalysis, microAnalysis) {
    let totalScore = 0;
    let count = 0;

    // Score each parameter (weighted)
    const weights = { pH: 20, nitrogen: 20, phosphorus: 15, potassium: 15, organicMatter: 20, ec: 10 };

    Object.entries(macroAnalysis).forEach(([param, data]) => {
      const weight = weights[param] || 10;
      totalScore += data.optimality * (weight / 100);
      count += weight;
    });

    // Slightly boost if micronutrients are good
    if (microAnalysis) {
      let microScore = 100;
      Object.values(microAnalysis).forEach(data => {
        if (data.status === 'Deficient') microScore -= 15;
        else if (data.status === 'Low') microScore -= 8;
      });
      totalScore += microScore * 0.1;
    }

    return {
      overall: Math.round(Math.min(100, totalScore)),
      macro: Math.round(totalScore)
    };
  }

  /**
   * Get grade based on score
   */
  getGrade(score) {
    if (score >= 85) return 'A+ (Excellent)';
    if (score >= 75) return 'A (Very Good)';
    if (score >= 60) return 'B (Good)';
    if (score >= 45) return 'C (Fair)';
    return 'D (Poor)';
  }

  /**
   * Get status message
   */
  getStatus(score) {
    if (score >= 80) return 'Highly Suitable for farming';
    if (score >= 60) return 'Suitable with minor amendments';
    if (score >= 40) return 'Requires improvement before cultivation';
    return 'Critical improvements needed';
  }

  /**
   * Get color indicator
   */
  getColor(score) {
    if (score >= 75) return 'Green';
    if (score >= 60) return 'Yellow';
    return 'Red';
  }

  /**
   * Get range description
   */
  getStatusRange(value, standard) {
    const { min, max } = standard;
    if (value < min) return `Below optimal (Standard: ${min}-${max})`;
    if (value > max) return `Above optimal (Standard: ${min}-${max})`;
    return `Within optimal range (${min}-${max})`;
  }

  /**
   * Generate improvement suggestions
   */
  generateImprovements(input, analysis, standards) {
    const improvements = [];

    Object.entries(analysis).forEach(([param, data]) => {
      if (data.status !== 'Optimal') {
        improvements.push({
          parameter: param,
          current: data.value,
          target: standards[param === 'ec' ? 'EC' : param.charAt(0).toUpperCase() + param.slice(1)].optimal,
          status: data.status,
          action: data.recommendation,
          priority: this.getPriority(param, data.status)
        });
      }
    });

    return improvements.sort((a, b) => {
      const priorityOrder = { Critical: 1, High: 2, Medium: 3, Low: 4 };
      return priorityOrder[a.priority] - priorityOrder[b.priority];
    });
  }

  /**
   * Get priority level
   */
  getPriority(param, status) {
    if (param === 'pH' && status !== 'Optimal') return 'Critical';
    if (status === 'Deficient' || status === 'Excessive') return 'High';
    return 'Medium';
  }

  /**
   * Generate action plan
   */
  generateActionPlan(improvements) {
    const plan = [];

    improvements.slice(0, 3).forEach((improvement, index) => {
      plan.push({
        step: index + 1,
        action: improvement.action,
        timeline: '2-4 weeks before sowing',
        expectedOutcome: `${improvement.parameter} improved towards optimal level`
      });
    });

    return plan;
  }

  /**
   * Generate timeline
   */
  generateTimeline(improvements) {
    return {
      immediate: improvements.filter(i => i.priority === 'Critical'),
      nextWeek: improvements.filter(i => i.priority === 'High'),
      beforeSowing: improvements.filter(i => i.priority === 'Medium')
    };
  }

  /**
   * Estimate cost of improvements
   */
  estimateCost(improvements) {
    let totalCost = 0;

    improvements.forEach(improvement => {
      if (improvement.parameter === 'pH') {
        totalCost += 2000; // Lime/Sulfur
      } else if (improvement.parameter === 'organicMatter') {
        totalCost += 5000; // Farmyard manure
      } else {
        totalCost += 3000; // Fertilizers
      }
    });

    return totalCost;
  }

  /**
   * Generate warnings
   */
  generateWarnings(input, standards) {
    const warnings = [];

    if (input.pH < 5.5 || input.pH > 8.5) {
      warnings.push('Extreme pH may require professional consultation');
    }

    if (input.ec > 4) {
      warnings.push('High salinity detected. Salt-tolerant crop selection recommended');
    }

    if (input.organicMatter < 0.5) {
      warnings.push('Very low organic matter. Soil degradation risk is high');
    }

    return warnings;
  }

  /**
   * Check certifications
   */
  checkCertifications(input) {
    const certs = [];

    if (input.organicMatter > 1.5) {
      certs.push('Eligible for Organic certification');
    }

    if (input.ec < 2 && input.nitrogen > 150) {
      certs.push('Suitable for high-value crops');
    }

    return certs;
  }

  /**
   * Get next test date
   */
  getNextTestDate() {
    const date = new Date();
    date.setMonth(date.getMonth() + 3);
    return date.toISOString().split('T')[0];
  }

  /**
   * Generate compliance report
   */
  generateComplianceReport(input, standards, crop) {
    let compliantParams = 0;
    let totalParams = 6;

    Object.entries({
      pH: input.pH,
      N: input.nitrogen,
      P: input.phosphorus,
      K: input.potassium,
      OM: input.organicMatter,
      EC: input.ec
    }).forEach(([param, value]) => {
      const std = standards[param.length === 1 ? param : param.toLowerCase()];
      if (value >= std.min && value <= std.max) {
        compliantParams++;
      }
    });

    return {
      compliancePercentage: Math.round((compliantParams / totalParams) * 100),
      compliantParameters: compliantParams,
      nonCompliantParameters: totalParams - compliantParams,
      overallCompliance: compliantParams === totalParams ? 'Compliant' : 'Non-Compliant'
    };
  }

  /**
   * Get default standards for crops not in database
   */
  getDefaultStandards() {
    return {
      pH: { min: 6.5, max: 7.5, optimal: 7.0 },
      N: { min: 250, max: 350, optimal: 300 },
      P: { min: 20, max: 40, optimal: 30 },
      K: { min: 200, max: 350, optimal: 250 },
      OM: { min: 2.0, max: 3.5, optimal: 2.5 },
      EC: { min: 0, max: 2, optimal: 0.5 }
    };
  }
}

module.exports = new SoilHealthService();
