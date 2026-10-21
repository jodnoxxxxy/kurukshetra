// Cost Calculator Controller
const costService = require('../services/cost.service');
const logger = require('../utils/logger');

class CostCalculatorController {
  /**
   * POST /api/v1/cost-calc/calculate
   * Calculate farm economics for a specific crop
   */
  async calculateCost(req, res) {
    try {
      const { crop, landArea, costs } = req.body;

      // Validation
      if (!crop || !landArea) {
        return res.status(400).json({
          success: false,
          message: 'crop and landArea are required'
        });
      }

      if (landArea < 0.01 || landArea > 1000) {
        return res.status(400).json({
          success: false,
          message: 'Land area must be between 0.01 and 1000 hectares'
        });
      }

      const result = costService.calculateCost({
        crop,
        landArea,
        costs
      });

      return res.status(200).json({
        success: true,
        data: result,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Cost calculation error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error calculating costs'
      });
    }
  }

  /**
   * POST /api/v1/cost-calc/compare
   * Compare economics across multiple crops
   */
  async compareCrops(req, res) {
    try {
      const { crops, landArea } = req.body;

      if (!crops || !Array.isArray(crops) || crops.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'crops array is required and must contain at least one crop'
        });
      }

      if (!landArea || landArea < 0.01 || landArea > 1000) {
        return res.status(400).json({
          success: false,
          message: 'landArea is required and must be between 0.01 and 1000 hectares'
        });
      }

      const result = costService.getComparativeAnalysis(crops, landArea);

      return res.status(200).json({
        success: true,
        data: result,
        comparedCrops: crops.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Cost comparison error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error comparing costs'
      });
    }
  }

  /**
   * GET /api/v1/cost-calc/crops
   * Get cost data for all available crops
   */
  async getAllCropsCostData(req, res) {
    try {
      const crops = Object.entries(costService.COST_DATABASE).map(([name, data]) => ({
        name,
        costPerAcre: data.costPerAcre,
        expectedYield: data.expectedYield,
        yieldUnit: data.yieldUnit,
        marketPrice: data.marketPrice,
        expectedRevenue: data.expectedRevenue,
        profitPerAcre: data.profitPerAcre
      }));

      return res.status(200).json({
        success: true,
        data: crops,
        count: crops.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching crop data:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching crop data'
      });
    }
  }

  /**
   * GET /api/v1/cost-calc/crop/:crop
   * Get detailed cost data for a specific crop
   */
  async getCropCostData(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const cropData = costService.COST_DATABASE[crop.toUpperCase()];

      if (!cropData) {
        return res.status(404).json({
          success: false,
          message: `Cost data for crop '${crop}' not found`
        });
      }

      return res.status(200).json({
        success: true,
        crop,
        data: cropData,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching crop cost data:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching crop cost data'
      });
    }
  }

  /**
   * POST /api/v1/cost-calc/roi-analysis
   * Analyze Return on Investment for specific crop and investment
   */
  async analyzeROI(req, res) {
    try {
      const { crop, landArea, investment } = req.body;

      if (!crop || !landArea || !investment) {
        return res.status(400).json({
          success: false,
          message: 'crop, landArea, and investment are required'
        });
      }

      const roiAnalysis = costService.generateROIAnalysis({
        crop,
        landArea,
        investment
      });

      return res.status(200).json({
        success: true,
        data: roiAnalysis,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('ROI analysis error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error analyzing ROI'
      });
    }
  }
}

module.exports = new CostCalculatorController();
