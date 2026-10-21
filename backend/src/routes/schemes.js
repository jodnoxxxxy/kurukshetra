// backend/src/routes/schemes.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const schemeService = require('../services/scheme.service');
const logger = require('../utils/logger');

// Validation schemas
const findSchemesSchema = Joi.object({
  crop: Joi.string().required(),
  landArea: Joi.number().min(0.01).max(1000).required(),
  income: Joi.number().min(0).optional(),
  location: Joi.string().optional()
});

/**
 * POST /api/v1/schemes/find
 * Find government schemes matching farmer eligibility
 */
router.post('/find', async (req, res) => {
  try {
    const { error } = findSchemesSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const schemes = schemeService.findMatchingSchemes(req.body);

    return res.status(200).json({
      success: true,
      data: schemes,
      count: schemes.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Scheme finder error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error finding schemes'
    });
  }
});

/**
 * GET /api/v1/schemes/scheme/:schemeId
 * Get detailed information about a specific scheme
 */
router.get('/scheme/:schemeId', async (req, res) => {
  try {
    const { schemeId } = req.params;

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
  } catch (err) {
    logger.error('Error fetching scheme details:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching scheme details'
    });
  }
});

/**
 * GET /api/v1/schemes/application-steps/:schemeId
 * Get step-by-step application process
 */
router.get('/application-steps/:schemeId', async (req, res) => {
  try {
    const { schemeId } = req.params;

    const scheme = Object.values(schemeService.SCHEMES).find(
      s => s.id === schemeId || s.name.toLowerCase().includes(schemeId.toLowerCase())
    );

    if (!scheme) {
      return res.status(404).json({
        success: false,
        message: `Scheme '${schemeId}' not found`
      });
    }

    const steps = schemeService.getApplicationSteps(schemeId);

    return res.status(200).json({
      success: true,
      data: {
        scheme: scheme.name,
        steps,
        totalSteps: steps.length,
        estimatedTime: '15-20 days'
      },
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching application steps:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching application steps'
    });
  }
});

/**
 * GET /api/v1/schemes/all
 * Get list of all available schemes
 */
router.get('/all', async (req, res) => {
  try {
    const schemes = Object.values(schemeService.SCHEMES).map(scheme => ({
      id: scheme.id,
      name: scheme.name,
      type: scheme.type,
      targetGroup: scheme.targetGroup,
      benefit: scheme.benefit,
      deadline: scheme.deadline
    }));

    return res.status(200).json({
      success: true,
      data: schemes,
      count: schemes.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching schemes list:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching schemes'
    });
  }
});

module.exports = router;
