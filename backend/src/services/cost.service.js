// backend/src/services/cost.service.js

/**
 * COST CALCULATOR SERVICE
 * Estimates total farming costs and profit for a crop cycle
 * 
 * Components: Seeds, Fertilizers, Labor, Irrigation, Pesticides, Equipment, etc.
 */

class CostCalculatorService {
  constructor() {
    // Cost estimates by crop and component (per hectare)
    this.COST_DATABASE = {
      rice: {
        seeds: 1500,
        fertilizers: 4000,
        labor: 8000,
        irrigation: 2500,
        pesticides: 1500,
        equipment: 3000,
        harvesting: 4000,
        total: 24500,
        expectedYield: 50, // quintals
        marketPrice: 2200, // rupees per quintal (varies)
        expectedRevenue: 110000
      },
      wheat: {
        seeds: 1200,
        fertilizers: 3500,
        labor: 6500,
        irrigation: 2000,
        pesticides: 1000,
        equipment: 2500,
        harvesting: 3000,
        total: 19700,
        expectedYield: 45,
        marketPrice: 2500,
        expectedRevenue: 112500
      },
      maize: {
        seeds: 2000,
        fertilizers: 3000,
        labor: 5000,
        irrigation: 1500,
        pesticides: 1500,
        equipment: 2000,
        harvesting: 2500,
        total: 17500,
        expectedYield: 40,
        marketPrice: 1800,
        expectedRevenue: 72000
      },
      cotton: {
        seeds: 3000,
        fertilizers: 6000,
        labor: 12000,
        irrigation: 3000,
        pesticides: 3500,
        equipment: 4000,
        harvesting: 5000,
        total: 36500,
        expectedYield: 20,
        marketPrice: 5500,
        expectedRevenue: 110000
      },
      sugarcane: {
        seeds: 4000,
        fertilizers: 8000,
        labor: 18000,
        irrigation: 5000,
        pesticides: 2000,
        equipment: 5000,
        harvesting: 6000,
        total: 48000,
        expectedYield: 65,
        marketPrice: 3200,
        expectedRevenue: 208000
      },
      potato: {
        seeds: 20000,
        fertilizers: 4000,
        labor: 7000,
        irrigation: 3000,
        pesticides: 2000,
        equipment: 2500,
        harvesting: 4000,
        total: 42500,
        expectedYield: 35,
        marketPrice: 1200,
        expectedRevenue: 42000
      },
      tomato: {
        seeds: 5000,
        fertilizers: 5000,
        labor: 10000,
        irrigation: 4000,
        pesticides: 3000,
        equipment: 3000,
        harvesting: 5000,
        total: 35000,
        expectedYield: 35,
        marketPrice: 1500,
        expectedRevenue: 52500
      }
    };

    // Labor hours required at different stages
    this.LABOR_REQUIREMENTS = {
      landPrep: 50,      // hours/hectare
      sowing: 30,
      maintenance: 80,
      irrigation: 40,
      harvesting: 100,
      processing: 50
    };

    // Wage rates
    this.WAGE_RATES = {
      skilled: 300,      // rupees per hour
      semiskilled: 200,
      unskilled: 150,
      machinery: 500     // per hour for machine operation
    };
  }

  /**
   * Calculate detailed cost breakdown for farming
   * 
   * @param {Object} input - Input parameters
   * @param {string} input.crop - Crop name
   * @param {number} input.landArea - Land area in hectares
   * @param {Object} input.costs - Custom cost overrides (optional)
   * @returns {Object} - Detailed cost and profit analysis
   */
  calculateCost(input) {
    this.validateInput(input);

    const crop = input.crop.toLowerCase();
    const baseCost = this.COST_DATABASE[crop];

    if (!baseCost) {
      throw new Error(`Crop '${input.crop}' not found in database`);
    }

    // Scale costs to land area
    const scaledCosts = this.scaleCostsByArea(baseCost, input.landArea);

    // Apply custom overrides if provided
    const finalCosts = input.costs 
      ? { ...scaledCosts, ...input.costs }
      : scaledCosts;

    // Calculate total investment
    const totalInvestment = Object.values(finalCosts).reduce((sum, cost) => sum + (cost || 0), 0);

    // Calculate expected revenue
    const totalYield = baseCost.expectedYield * input.landArea;
    const expectedRevenue = totalYield * baseCost.marketPrice;

    // Calculate profit/loss
    const expectedProfit = expectedRevenue - totalInvestment;
    const profitMargin = (expectedProfit / totalInvestment) * 100;
    const roi = ((expectedProfit / totalInvestment) * 100).toFixed(2);
    const breakEvenYield = (totalInvestment / baseCost.marketPrice) / input.landArea;

    return {
      success: true,
      crop: input.crop,
      landArea: input.landArea,
      costBreakdown: {
        seeds: finalCosts.seeds || 0,
        fertilizers: finalCosts.fertilizers || 0,
        labor: finalCosts.labor || 0,
        irrigation: finalCosts.irrigation || 0,
        pesticides: finalCosts.pesticides || 0,
        equipment: finalCosts.equipment || 0,
        harvesting: finalCosts.harvesting || 0,
        misc: finalCosts.misc || 0,
        total: totalInvestment
      },
      expectedYield: {
        perHectare: baseCost.expectedYield,
        total: totalYield,
        unit: 'quintals'
      },
      marketAnalysis: {
        marketPrice: baseCost.marketPrice,
        unit: 'rupees/quintal',
        priceVariation: {
          low: Math.round(baseCost.marketPrice * 0.8),
          medium: baseCost.marketPrice,
          high: Math.round(baseCost.marketPrice * 1.2)
        }
      },
      profitAnalysis: {
        scenarioLow: {
          yield: Math.round(totalYield * 0.8),
          revenue: Math.round(totalYield * 0.8 * baseCost.marketPrice * 0.8),
          profit: Math.round((totalYield * 0.8 * baseCost.marketPrice * 0.8) - totalInvestment),
          margin: Math.round(((totalYield * 0.8 * baseCost.marketPrice * 0.8 - totalInvestment) / totalInvestment) * 100)
        },
        scenarioMedium: {
          yield: totalYield,
          revenue: expectedRevenue,
          profit: expectedProfit,
          margin: profitMargin.toFixed(2)
        },
        scenarioHigh: {
          yield: Math.round(totalYield * 1.2),
          revenue: Math.round(totalYield * 1.2 * baseCost.marketPrice * 1.2),
          profit: Math.round((totalYield * 1.2 * baseCost.marketPrice * 1.2) - totalInvestment),
          margin: Math.round(((totalYield * 1.2 * baseCost.marketPrice * 1.2 - totalInvestment) / totalInvestment) * 100)
        }
      },
      breakEvenAnalysis: {
        breakEvenYield: breakEvenYield.toFixed(2),
        breakEvenYieldTotal: Math.round(breakEvenYield * input.landArea),
        unit: 'quintals/hectare',
        message: `Need ${breakEvenYield.toFixed(2)} quintals/hectare to break even`
      },
      roi: `${roi}%`,
      paybackPeriod: this.calculatePayback(totalInvestment, expectedProfit),
      riskFactors: this.identifyRisks(crop, input.landArea),
      recommendations: this.getRecommendations(expectedProfit, roi),
      costOptimization: this.suggestOptimizations(crop, finalCosts)
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

    if (errors.length > 0) {
      throw new Error(`Validation Error: ${errors.join(', ')}`);
    }
  }

  /**
   * Scale base costs by land area
   */
  scaleCostsByArea(baseCost, landArea) {
    const scaled = {};
    
    Object.entries(baseCost).forEach(([key, value]) => {
      if (typeof value === 'number' && key !== 'marketPrice' && key !== 'expectedYield') {
        scaled[key] = Math.round(value * landArea);
      }
    });

    return scaled;
  }

  /**
   * Calculate payback period in months
   */
  calculatePayback(investment, monthlyProfit) {
    if (monthlyProfit <= 0) {
      return 'Not profitable';
    }

    const months = investment / (monthlyProfit / 12);
    if (months > 60) return 'Very Long (>5 years)';
    if (months > 24) return `${Math.round(months / 12)} years`;
    return `${Math.round(months)} months`;
  }

  /**
   * Identify risk factors
   */
  identifyRisks(crop, landArea) {
    const risks = [
      {
        factor: 'Weather Risk',
        impact: 'High',
        mitigation: 'Use drought-resistant varieties, install irrigation'
      },
      {
        factor: 'Market Price Volatility',
        impact: 'Medium',
        mitigation: 'Diversify crops, contract farming with buyer'
      },
      {
        factor: 'Pest & Disease',
        impact: 'High',
        mitigation: 'Integrated Pest Management, use resistant varieties'
      },
      {
        factor: 'Soil Degradation',
        impact: 'Medium',
        mitigation: 'Crop rotation, organic matter addition'
      }
    ];

    if (landArea > 10) {
      risks.push({
        factor: 'Labor Availability',
        impact: 'High',
        mitigation: 'Mechanization, timely hiring, skill development'
      });
    }

    return risks;
  }

  /**
   * Get profit recommendations
   */
  getRecommendations(profit, roi) {
    const recommendations = [];

    if (parseFloat(roi) > 50) {
      recommendations.push('Excellent profitability! Consider scaling up');
    } else if (parseFloat(roi) > 30) {
      recommendations.push('Good profit margin. Maintain current practices');
    } else if (parseFloat(roi) > 0) {
      recommendations.push('Adequate return. Look for cost optimization opportunities');
    } else {
      recommendations.push('Low/Negative profit. Consider crop diversification');
    }

    if (profit > 100000) {
      recommendations.push('Strong earnings - consider reinvestment in soil health');
    }

    return recommendations;
  }

  /**
   * Suggest cost optimization opportunities
   */
  suggestOptimizations(crop, costs) {
    const suggestions = [];

    // Labor optimization
    if (costs.labor > 8000) {
      suggestions.push({
        area: 'Labor',
        current: costs.labor,
        suggestion: 'Use mechanized cultivation to reduce labor by 30%',
        potentialSaving: Math.round(costs.labor * 0.30)
      });
    }

    // Fertilizer optimization
    if (costs.fertilizers > 4000) {
      suggestions.push({
        area: 'Fertilizers',
        current: costs.fertilizers,
        suggestion: 'Use bio-fertilizers and organic manure for 20% saving',
        potentialSaving: Math.round(costs.fertilizers * 0.20)
      });
    }

    // Irrigation efficiency
    if (costs.irrigation > 2000) {
      suggestions.push({
        area: 'Irrigation',
        current: costs.irrigation,
        suggestion: 'Install drip irrigation system for 25% water saving',
        potentialSaving: Math.round(costs.irrigation * 0.25)
      });
    }

    // Pesticide optimization
    if (costs.pesticides > 2000) {
      suggestions.push({
        area: 'Pesticides',
        current: costs.pesticides,
        suggestion: 'Use biological pest control methods for 30% reduction',
        potentialSaving: Math.round(costs.pesticides * 0.30)
      });
    }

    return suggestions;
  }

  /**
   * Get comparative analysis with other crops
   */
  getComparativeAnalysis(crops, landArea) {
    const analysis = [];

    crops.forEach(cropName => {
      const crop = cropName.toLowerCase();
      if (this.COST_DATABASE[crop]) {
        const cost = this.COST_DATABASE[crop];
        const investment = cost.total * landArea;
        const revenue = cost.expectedYield * landArea * cost.marketPrice;
        const profit = revenue - investment;
        const roi = ((profit / investment) * 100).toFixed(2);

        analysis.push({
          cropName,
          totalCost: investment,
          expectedRevenue: revenue,
          expectedProfit: profit,
          roi: `${roi}%`,
          rank: 0 // Will be assigned after sorting
        });
      }
    });

    // Rank by ROI
    analysis.sort((a, b) => parseFloat(b.roi) - parseFloat(a.roi));
    analysis.forEach((item, index) => {
      item.rank = index + 1;
    });

    return analysis;
  }
}

module.exports = new CostCalculatorService();
