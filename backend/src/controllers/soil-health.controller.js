// Soil Health Controller
const soilService = require('../services/soil.service');
const logger = require('../utils/logger');

class SoilHealthController {
  /**
   * POST /api/v1/soil-health/analyze
   * Generate comprehensive soil health analysis and recommendations
   */
  async analyzeSoil(req, res) {
    try {
      const { pH, nitrogen, phosphorus, potassium, organicMatter, ec, crop, micronutrients } = req.body;

      // Validation
      if (typeof pH !== 'number' || typeof nitrogen !== 'number' || 
          typeof phosphorus !== 'number' || typeof potassium !== 'number') {
        return res.status(400).json({
          success: false,
          message: 'pH, nitrogen, phosphorus, and potassium are required and must be numbers'
        });
      }

      if (pH < 0 || pH > 14) {
        return res.status(400).json({
          success: false,
          message: 'pH must be between 0 and 14'
        });
      }

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'crop is required'
        });
      }

      // Analyze soil
      const result = soilService.generateSoilHealthCard({
        pH,
        nitrogen,
        phosphorus,
        potassium,
        organicMatter,
        ec,
        crop,
        micronutrients
      });

      return res.status(200).json({
        success: true,
        data: result,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Soil analysis error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error analyzing soil'
      });
    }
  }

  /**
   * GET /api/v1/soil-health/standards/:crop
   * Get optimal soil standards for a specific crop
   */
  async getSoilStandards(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const standards = soilService.SOIL_STANDARDS[crop.toUpperCase()] || 
                       soilService.getDefaultStandards();

      return res.status(200).json({
        success: true,
        crop,
        standards,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching soil standards:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching soil standards'
      });
    }
  }

  /**
   * GET /api/v1/soil-health/micronutrient-standards
   * Get micronutrient reference standards and optimal ranges
   */
  async getMicronutrientStandards(req, res) {
    try {
      const standards = soilService.MICRONUTRIENT_STANDARDS;

      return res.status(200).json({
        success: true,
        data: standards,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching micronutrient standards:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching micronutrient standards'
      });
    }
  }

  /**
   * POST /api/v1/soil-health/improvement-plan
   * Generate soil improvement plan based on current analysis
   */
  async generateImprovementPlan(req, res) {
    try {
      const { pH, nitrogen, phosphorus, potassium, organicMatter, crop, duration } = req.body;

      if (!crop || typeof pH !== 'number') {
        return res.status(400).json({
          success: false,
          message: 'crop and pH are required'
        });
      }

      const plan = soilService.generateSoilImprovementPlan({
        pH,
        nitrogen,
        phosphorus,
        potassium,
        organicMatter,
        crop,
        duration: duration || 'singleSeason'
      });

      return res.status(200).json({
        success: true,
        data: plan,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error generating improvement plan:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error generating improvement plan'
      });
    }
  }

  /**
   * GET /api/v1/soil-health/crops
   * Get list of all supported crops
   */
  async getSupportedCrops(req, res) {
    try {
      const crops = Object.keys(soilService.SOIL_STANDARDS);

      return res.status(200).json({
        success: true,
        data: crops,
        count: crops.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching supported crops:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching supported crops'
      });
    }
  }
}

module.exports = new SoilHealthController();
