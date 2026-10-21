// backend/src/routes/soil-health.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const soilService = require('../services/soil.service');
const logger = require('../utils/logger');

// Validation schema
const soilAnalysisSchema = Joi.object({
  pH: Joi.number().min(0).max(14).required(),
  nitrogen: Joi.number().min(0).max(3000).required(),
  phosphorus: Joi.number().min(0).max(500).required(),
  potassium: Joi.number().min(0).max(2000).required(),
  organicMatter: Joi.number().min(0).max(10).required(),
  ec: Joi.number().min(0).max(10).required(),
  crop: Joi.string().required(),
  micronutrients: Joi.object().optional()
});

/**
 * POST /api/v1/soil-health/analyze
 * Generate comprehensive soil health card
 */
router.post('/analyze', async (req, res) => {
  try {
    const { error } = soilAnalysisSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = soilService.generateSoilHealthCard(req.body);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Soil analysis error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error analyzing soil'
    });
  }
});

/**
 * GET /api/v1/soil-health/standards/:crop
 * Get soil standards for specific crop
 */
router.get('/standards/:crop', async (req, res) => {
  try {
    const { crop } = req.params;

    if (!crop) {
      return res.status(400).json({
        success: false,
        message: 'Crop parameter required'
      });
    }

    const standards = soilService.SOIL_STANDARDS[crop.toLowerCase()] || soilService.getDefaultStandards();

    return res.status(200).json({
      success: true,
      crop,
      standards
    });
  } catch (err) {
    logger.error('Error fetching soil standards:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching soil standards'
    });
  }
});

/**
 * GET /api/v1/soil-health/micronutrient-standards
 * Get micronutrient reference standards
 */
router.get('/micronutrient-standards', async (req, res) => {
  try {
    return res.status(200).json({
      success: true,
      data: soilService.MICRONUTRIENT_STANDARDS
    });
  } catch (err) {
    logger.error('Error fetching micronutrient standards:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching standards'
    });
  }
});

module.exports = router;
