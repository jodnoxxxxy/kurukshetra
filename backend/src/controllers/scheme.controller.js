// Government Schemes Controller
const schemeService = require('../services/scheme.service');
const logger = require('../utils/logger');

class SchemeController {
  /**
   * POST /api/v1/schemes/find
   * Find government schemes matching farmer eligibility criteria
   */
  async findMatchingSchemes(req, res) {
    try {
      const { crop, landArea, age, state } = req.body;

      // Validation
      if (!crop || landArea === undefined) {
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

      if (!state) {
        return res.status(400).json({
          success: false,
          message: 'state is required'
        });
      }

      // Map landArea to landSize for service
      const schemes = schemeService.findMatchingSchemes({
        crop,
        landSize: landArea,
        age: age || null,
        state
      });

      return res.status(200).json({
        success: true,
        data: schemes,
        count: schemes.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Scheme finder error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error finding schemes'
      });
    }
  }

  /**
   * GET /api/v1/schemes/all
   * Get all available government schemes
   */
  async getAllSchemes(req, res) {
    try {
      const schemes = Object.values(schemeService.SCHEMES);

      return res.status(200).json({
        success: true,
        data: schemes,
        count: schemes.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching all schemes:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching schemes'
      });
    }
  }

  /**
   * GET /api/v1/schemes/scheme/:schemeId
   * Get detailed information about a specific scheme
   */
  async getSchemeDetails(req, res) {
    try {
      const { schemeId } = req.params;

      if (!schemeId) {
        return res.status(400).json({
          success: false,
          message: 'Scheme ID is required'
        });
      }

      const scheme = Object.values(schemeService.SCHEMES).find(
        s => s.id === schemeId || s.name.toLowerCase().includes(schemeId.toLowerCase())
      );

      if (!scheme) {
        return res.status(404).json({
          success: false,
          message: `Scheme '${schemeId}' not found`
        });
      }

      return res.status(200).json({
        success: true,
        data: scheme,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching scheme details:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching scheme details'
      });
    }
  }

  /**
   * GET /api/v1/schemes/eligibility/:schemeId
   * Check eligibility for a specific scheme
   */
  async checkEligibility(req, res) {
    try {
      const { schemeId } = req.params;
      const { crop, landArea, age, state } = req.query;

      if (!schemeId) {
        return res.status(400).json({
          success: false,
          message: 'Scheme ID is required'
        });
      }

      const scheme = Object.values(schemeService.SCHEMES).find(
        s => s.id === schemeId
      );

      if (!scheme) {
        return res.status(404).json({
          success: false,
          message: `Scheme '${schemeId}' not found`
        });
      }

      const eligibility = schemeService.checkEligibilityForScheme(scheme, {
        crop,
        landSize: landArea ? parseFloat(landArea) : null,
        age: age ? parseInt(age) : null,
        state
      });

      return res.status(200).json({
        success: true,
        schemeId,
        schemeName: scheme.name,
        eligibility,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error checking eligibility:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error checking eligibility'
      });
    }
  }

  /**
   * GET /api/v1/schemes/by-crop/:crop
   * Get schemes specific to a crop
   */
  async getSchemesByCrop(req, res) {
    try {
      const { crop } = req.params;

      if (!crop) {
        return res.status(400).json({
          success: false,
          message: 'Crop parameter is required'
        });
      }

      const schemes = Object.values(schemeService.SCHEMES).filter(
        s => s.applicableCrops.includes(crop.toUpperCase()) || 
             s.applicableCrops.includes('All')
      );

      return res.status(200).json({
        success: true,
        crop,
        data: schemes,
        count: schemes.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching schemes by crop:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching schemes'
      });
    }
  }

  /**
   * GET /api/v1/schemes/by-state/:state
   * Get schemes available in a specific state
   */
  async getSchemesByState(req, res) {
    try {
      const { state } = req.params;

      if (!state) {
        return res.status(400).json({
          success: false,
          message: 'State parameter is required'
        });
      }

      const schemes = Object.values(schemeService.SCHEMES).filter(
        s => !s.applicableStates || s.applicableStates.includes(state.toUpperCase()) ||
             s.applicableStates.includes('ALL')
      );

      return res.status(200).json({
        success: true,
        state,
        data: schemes,
        count: schemes.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching schemes by state:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching schemes'
      });
    }
  }
}

module.exports = new SchemeController();
