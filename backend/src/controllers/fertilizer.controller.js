// Fertilizer Calculator Controller
const fertilizerService = require('../services/fertilizer.service');
const logger = require('../utils/logger');

class FertilizerController {
  /**
   * POST /api/v1/fertilizer/calculate
   * Calculate fertilizer requirement based on soil and crop data
   */
  async calculateRequirement(req, res) {
    try {
      const { crop, landArea, soilNutrients, budget } = req.body;

      // Validation
      if (!crop || !landArea || !soilNutrients) {
        return res.status(400).json({
          success: false,
          message: 'crop, landArea, and soilNutrients are required'
        });
      }

      if (landArea < 0.01 || landArea > 1000) {
        return res.status(400).json({
          success: false,
          message: 'Land area must be between 0.01 and 1000 hectares'
        });
      }

      // Validate soil nutrients
      const { N, P, K } = soilNutrients;
      if (typeof N !== 'number' || typeof P !== 'number' || typeof K !== 'number') {
        return res.status(400).json({
          success: false,
          message: 'Soil nutrients N, P, K must be numbers'
        });
      }

      // Calculate fertilizer requirement
      const result = fertilizerService.calculateRequirement({
        crop,
        landArea,
        soilNutrients,
        budget
      });

      return res.status(200).json({
        success: true,
        data: result,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Fertilizer calculation error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error calculating fertilizer requirement'
      });
    }
  }

  /**
   * GET /api/v1/fertilizer/recommendations/:crop
   * Get fertilizer recommendations for specific crop
   */
  async getRecommendations(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const recommendations = fertilizerService.getRecommendations(crop);

      return res.status(200).json({
        success: true,
        data: recommendations,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching fertilizer recommendations:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching recommendations'
      });
    }
  }

  /**
   * GET /api/v1/fertilizer/standards/:crop
   * Get nutrient standards for specific crop
   */
  async getStandards(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const standards = fertilizerService.SOIL_STANDARDS[crop.toUpperCase()] || 
                       fertilizerService.getDefaultStandards();

      return res.status(200).json({
        success: true,
        crop,
        standards,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching fertilizer standards:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching standards'
      });
    }
  }

  /**
   * POST /api/v1/fertilizer/budget-optimization
   * Optimize fertilizer selection based on budget
   */
  async optimizeByBudget(req, res) {
    try {
      const { crop, landArea, budget, soilNutrients } = req.body;

      if (!crop || !landArea || !budget) {
        return res.status(400).json({
          success: false,
          message: 'crop, landArea, and budget are required'
        });
      }

      const result = fertilizerService.optimizeFertilizerByBudget({
        crop,
        landArea,
        budget,
        soilNutrients
      });

      return res.status(200).json({
        success: true,
        data: result,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Budget optimization error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error optimizing fertilizer by budget'
      });
    }
  }
}

module.exports = new FertilizerController();
