// backend/src/routes/cost-calculator.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const costService = require('../services/cost.service');
const logger = require('../utils/logger');

// Validation schema
const costCalculationSchema = Joi.object({
  crop: Joi.string().required(),
  landArea: Joi.number().min(0.01).max(1000).required(),
  costs: Joi.object().optional()
});

const costComparisonSchema = Joi.object({
  crops: Joi.array().items(Joi.string()).required(),
  landArea: Joi.number().min(0.01).max(1000).required()
});

/**
 * POST /api/v1/cost-calc/calculate
 * Calculate farm economics and profit analysis
 */
router.post('/calculate', async (req, res) => {
  try {
    const { error } = costCalculationSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = costService.calculateCost(req.body);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Cost calculation error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error calculating costs'
    });
  }
});

/**
 * POST /api/v1/cost-calc/compare
 * Compare economics across multiple crops
 */
router.post('/compare', async (req, res) => {
  try {
    const { error } = costComparisonSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = costService.getComparativeAnalysis(req.body.crops, req.body.landArea);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Cost comparison error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error comparing costs'
    });
  }
});

/**
 * GET /api/v1/cost-calc/crops
 * Get cost data for all crops
 */
router.get('/crops', async (req, res) => {
  try {
    const crops = Object.entries(costService.COST_DATABASE).map(([name, data]) => ({
      name,
      costPerAcre: data.costPerAcre,
      expectedYield: data.expectedYield,
      marketPrice: data.marketPrice,
      expectedRevenue: data.expectedRevenue
    }));

    return res.status(200).json({
      success: true,
      data: crops,
      count: crops.length
    });
  } catch (err) {
    logger.error('Error fetching crop cost data:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching crop data'
    });
  }
});

module.exports = router;
