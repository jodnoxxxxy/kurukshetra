// Pest Detection Controller
const pestService = require('../services/pest.service');
const logger = require('../utils/logger');

class PestDetectionController {
  /**
   * POST /api/v1/pest-detection/identify
   * Identify pests from image or description
   */
  async identifyPest(req, res) {
    try {
      const { imageUrl, description, cropType, location } = req.body;

      if (!imageUrl && !description) {
        return res.status(400).json({
          success: false,
          message: 'Either imageUrl or description is required'
        });
      }

      if (!cropType) {
        return res.status(400).json({
          success: false,
          message: 'cropType is required'
        });
      }

      const result = pestService.identifyPests({
        imageUrl,
        description,
        cropType,
        location
      });

      return res.status(200).json({
        success: true,
        data: result,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Pest identification error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error identifying pest'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/pest/:pestId
   * Get detailed information about a specific pest
   */
  async getPestDetails(req, res) {
    try {
      const { pestId } = req.params;

      if (!pestId) {
        return res.status(400).json({
          success: false,
          message: 'Pest ID is required'
        });
      }

      const pest = pestService.getPestDetails(pestId);

      if (!pest) {
        return res.status(404).json({
          success: false,
          message: `Pest '${pestId}' not found`
        });
      }

      return res.status(200).json({
        success: true,
        data: pest,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching pest details:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching pest details'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/pest/:pestId/treatment
   * Get treatment recommendations for a specific pest
   */
  async getTreatmentRecommendations(req, res) {
    try {
      const { pestId } = req.params;
      const { organic } = req.query;

      if (!pestId) {
        return res.status(400).json({
          success: false,
          message: 'Pest ID is required'
        });
      }

      const treatments = pestService.getTreatmentOptions(
        pestId,
        organic === 'true'
      );

      if (!treatments || treatments.length === 0) {
        return res.status(404).json({
          success: false,
          message: `No treatments found for pest '${pestId}'`
        });
      }

      return res.status(200).json({
        success: true,
        pestId,
        includeOrganic: organic === 'true',
        data: treatments,
        count: treatments.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching treatments:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching treatment recommendations'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/crop/:crop/common-pests
   * Get list of common pests for a specific crop
   */
  async getCommonPests(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const pests = pestService.getCommonPests(crop);

      return res.status(200).json({
        success: true,
        crop,
        data: pests,
        count: pests.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching common pests:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching common pests'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/risk-assessment
   * Assess pest risk based on environmental conditions
   */
  async assessRisk(req, res) {
    try {
      const { cropType, temperature, humidity, rainfall, season } = req.query;

      if (!cropType) {
        return res.status(400).json({
          success: false,
          message: 'cropType is required'
        });
      }

      const riskAssessment = pestService.assessPestRisk({
        cropType,
        temperature: temperature ? parseFloat(temperature) : null,
        humidity: humidity ? parseFloat(humidity) : null,
        rainfall: rainfall ? parseFloat(rainfall) : null,
        season
      });

      return res.status(200).json({
        success: true,
        cropType,
        riskAssessment,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Risk assessment error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error assessing pest risk'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/all
   * Get list of all detectable pests
   */
  async getAllPests(req, res) {
    try {
      const pests = pestService.getAllPests();

      return res.status(200).json({
        success: true,
        data: pests,
        count: pests.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching all pests:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching pests'
      });
    }
  }

  /**
   * GET /api/v1/pest-detection/search
   * Search for pests by name or keywords
   */
  async searchPests(req, res) {
    try {
      const { query } = req.query;

      if (!query || query.trim().length === 0) {
        return res.status(400).json({
          success: false,
          message: 'Search query is required'
        });
      }

      const results = pestService.searchPests(query);

      return res.status(200).json({
        success: true,
        query,
        data: results,
        count: results.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Pest search error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error searching pests'
      });
    }
  }
}

module.exports = new PestDetectionController();
