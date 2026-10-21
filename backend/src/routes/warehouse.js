// backend/src/routes/warehouse.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const warehouseService = require('../services/warehouse.service');
const logger = require('../utils/logger');

// Validation schemas
const warehouseSearchSchema = Joi.object({
  latitude: Joi.number().min(-90).max(90).required(),
  longitude: Joi.number().min(-180).max(180).required(),
  capacity: Joi.number().min(100).optional(),
  maxDistance: Joi.number().min(1).max(500).default(50)
});

const bookingSchema = Joi.object({
  warehouseId: Joi.string().required(),
  cropType: Joi.string().required(),
  quantity: Joi.number().min(1).required(),
  duration: Joi.string().valid('monthly', 'quarterly', 'yearly').required(),
  farmerId: Joi.string().optional()
});

const withdrawalSchema = Joi.object({
  bookingId: Joi.string().required(),
  quantity: Joi.number().min(1).required(),
  date: Joi.date().iso().optional()
});

/**
 * POST /api/v1/warehouse/search
 * Search for warehouses near location
 */
router.post('/search', async (req, res) => {
  try {
    const { error } = warehouseSearchSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const warehouses = warehouseService.searchWarehouses(req.body);

    return res.status(200).json({
      success: true,
      data: warehouses,
      count: warehouses.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Warehouse search error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error searching warehouses'
    });
  }
});

/**
 * POST /api/v1/warehouse/book
 * Book storage space in warehouse
 */
router.post('/book', async (req, res) => {
  try {
    const { error } = bookingSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const booking = warehouseService.bookStorage(req.body);

    return res.status(201).json({
      success: true,
      data: booking,
      message: 'Booking confirmed successfully',
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Booking error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error processing booking'
    });
  }
});

/**
 * GET /api/v1/warehouse/booking/:bookingId
 * Get booking details and tracking information
 */
router.get('/booking/:bookingId', async (req, res) => {
  try {
    const { bookingId } = req.params;

    const details = warehouseService.getBookingDetails(bookingId);

    if (!details) {
      return res.status(404).json({
        success: false,
        message: `Booking '${bookingId}' not found`
      });
    }

    return res.status(200).json({
      success: true,
      data: details,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching booking details:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching booking details'
    });
  }
});

/**
 * POST /api/v1/warehouse/withdraw
 * Withdraw crop from warehouse storage
 */
router.post('/withdraw', async (req, res) => {
  try {
    const { error } = withdrawalSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = warehouseService.getBookingDetails(req.body.bookingId);

    if (!result) {
      return res.status(404).json({
        success: false,
        message: `Booking '${req.body.bookingId}' not found`
      });
    }

    const withdrawal = {
      id: `withdrawal_${Date.now()}`,
      bookingId: req.body.bookingId,
      quantityWithdrawn: req.body.quantity,
      remainingQuantity: result.storedQuantity - req.body.quantity,
      withdrawalDate: req.body.date || new Date().toISOString(),
      status: 'completed',
      charges: 0
    };

    return res.status(200).json({
      success: true,
      data: withdrawal,
      message: 'Withdrawal processed successfully',
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Withdrawal error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error processing withdrawal'
    });
  }
});

/**
 * GET /api/v1/warehouse/warehouses
 * Get list of all available warehouses
 */
router.get('/warehouses', async (req, res) => {
  try {
    const warehouses = Object.values(warehouseService.WAREHOUSES).map(w => ({
      id: w.id,
      name: w.name,
      location: w.location,
      capacity: w.capacity,
      currentUtilization: w.currentUtilization,
      pricePerUnit: w.pricePerUnit
    }));

    return res.status(200).json({
      success: true,
      data: warehouses,
      count: warehouses.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching warehouses:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching warehouses'
    });
  }
});

module.exports = router;
