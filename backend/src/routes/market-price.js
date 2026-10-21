// backend/src/routes/market-price.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const logger = require('../utils/logger');

// TODO: Move to service file when market.service.js is created
const CURRENT_MARKET_DATA = {
  'rice': { current: 2800, change: 2.5, location: 'Haryana' },
  'wheat': { current: 2400, change: 1.2, location: 'Punjab' },
  'corn': { current: 2200, change: -0.5, location: 'Karnataka' },
  'cotton': { current: 8500, change: 3.1, location: 'Gujarat' },
  'sugarcane': { current: 320, change: -1.2, location: 'Uttar Pradesh' },
  'potato': { current: 1800, change: 5.3, location: 'Himachal' },
  'onion': { current: 2100, change: 4.2, location: 'Maharashtra' }
};

// Validation schemas
const marketPriceSchema = Joi.object({
  crop: Joi.string().required(),
  location: Joi.string().optional()
});

const priceAlertSchema = Joi.object({
  crop: Joi.string().required(),
  targetPrice: Joi.number().min(0).required(),
  alertType: Joi.string().valid('above', 'below').default('above')
});

/**
 * GET /api/v1/market-price/crop/:crop
 * Get current market price for a crop
 */
router.get('/crop/:crop', async (req, res) => {
  try {
    const { crop } = req.params;
    const lowerCrop = crop.toLowerCase();

    const priceData = CURRENT_MARKET_DATA[lowerCrop];

    if (!priceData) {
      return res.status(404).json({
        success: false,
        message: `Price data not available for ${crop}`
      });
    }

    return res.status(200).json({
      success: true,
      data: {
        crop: crop.charAt(0).toUpperCase() + crop.slice(1),
        currentPrice: priceData.current,
        priceChangePercent: priceData.change,
        location: priceData.location,
        unit: 'Rs/Quintal',
        lastUpdated: new Date().toISOString()
      },
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Market price fetch error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching market prices'
    });
  }
});

/**
 * POST /api/v1/market-price/compare
 * Compare prices across multiple crops
 */
router.post('/compare', async (req, res) => {
  try {
    const { crops } = req.body;

    if (!Array.isArray(crops) || crops.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Crops array is required'
      });
    }

    const comparison = crops.map(crop => {
      const data = CURRENT_MARKET_DATA[crop.toLowerCase()];
      return {
        crop: crop.charAt(0).toUpperCase() + crop.slice(1),
        price: data ? data.current : 0,
        change: data ? data.change : 0,
        available: !!data
      };
    });

    const bestCrop = comparison
      .filter(c => c.available)
      .sort((a, b) => b.price - a.price)[0];

    return res.status(200).json({
      success: true,
      data: {
        comparison,
        bestOption: bestCrop,
        count: crops.length
      },
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Price comparison error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error comparing prices'
    });
  }
});

/**
 * POST /api/v1/market-price/set-alert
 * Set price alert for a crop
 */
router.post('/set-alert', async (req, res) => {
  try {
    const { error } = priceAlertSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const { crop, targetPrice, alertType } = req.body;
    const currentPrice = CURRENT_MARKET_DATA[crop.toLowerCase()]?.current || 0;

    const alert = {
      id: `alert_${Date.now()}`,
      crop: crop.charAt(0).toUpperCase() + crop.slice(1),
      targetPrice,
      alertType,
      currentPrice,
      status: 'active',
      createdAt: new Date().toISOString(),
      message: `Alert created. ${crop} price will notify when it goes ${alertType} Rs${targetPrice}`
    };

    return res.status(201).json({
      success: true,
      data: alert,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Alert creation error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error creating price alert'
    });
  }
});

/**
 * GET /api/v1/market-price/crops
 * Get market data for all available crops
 */
router.get('/crops', async (req, res) => {
  try {
    const crops = Object.entries(CURRENT_MARKET_DATA).map(([name, data]) => ({
      crop: name.charAt(0).toUpperCase() + name.slice(1),
      price: data.current,
      change: data.change,
      location: data.location,
      unit: 'Rs/Quintal'
    }));

    return res.status(200).json({
      success: true,
      data: crops,
      count: crops.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching crop prices:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching crop prices'
    });
  }
});

module.exports = router;
