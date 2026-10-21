// backend/src/routes/fertilizer.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const fertilizerService = require('../services/fertilizer.service');
const logger = require('../utils/logger');

// Validation schema
const fertilizerCalculationSchema = Joi.object({
  crop: Joi.string().required(),
  landArea: Joi.number().min(0.01).max(1000).required(),
  soilNutrients: Joi.object({
    N: Joi.number().min(0).max(3000).required(),
    P: Joi.number().min(0).max(500).required(),
    K: Joi.number().min(0).max(2000).required()
  }).required(),
  budget: Joi.string().valid('Low', 'Medium', 'High').optional()
});

/**
 * POST /api/v1/fertilizer/calculate
 * Calculate fertilizer requirement based on soil and crop
 */
router.post('/calculate', async (req, res) => {
  try {
    const { error } = fertilizerCalculationSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = fertilizerService.calculateRequirement(req.body);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Fertilizer calculation error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error calculating fertilizer requirement'
    });
  }
});

/**
 * GET /api/v1/fertilizer/nutrient/:nutrient
 * Get detailed nutrient information
 */
router.get('/nutrient/:nutrient', async (req, res) => {
  try {
    const { nutrient } = req.params;

    if (!['N', 'P', 'K'].includes(nutrient.toUpperCase())) {
      return res.status(400).json({
        success: false,
        message: 'Invalid nutrient. Must be N, P, or K'
      });
    }

    const info = fertilizerService.getNutrientInfo(nutrient.toUpperCase());

    return res.status(200).json({
      success: true,
      data: info
    });
  } catch (err) {
    logger.error('Error fetching nutrient info:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching nutrient information'
    });
  }
});

/**
 * GET /api/v1/fertilizer/types
 * Get all available fertilizer types
 */
router.get('/types', async (req, res) => {
  try {
    const types = Object.entries(fertilizerService.FERTILIZER_TYPES).map(([key, value]) => ({
      name: key,
      ...value
    }));

    return res.status(200).json({
      success: true,
      data: types,
      count: types.length
    });
  } catch (err) {
    logger.error('Error fetching fertilizer types:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching fertilizer types'
    });
  }
});

module.exports = router;
