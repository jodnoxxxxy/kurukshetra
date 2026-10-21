const express = require('express');
const router = express.Router();
const Joi = require('joi');
const otpService = require('../services/otp.service');
const logger = require('../utils/logger');

// Validation schemas
const sendOTPSchema = Joi.object({
  phone: Joi.string().pattern(/^[6-9]\d{9}$/).required().messages({
    'string.pattern.base': 'Phone must be a valid 10-digit Indian number'
  }),
  email: Joi.string().email().optional()
}).unknown(true);

const verifyOTPSchema = Joi.object({
  phone: Joi.string().pattern(/^[6-9]\d{9}$/).required(),
  otp: Joi.string().length(6).pattern(/^\d+$/).required().messages({
    'string.length': 'OTP must be 6 digits',
    'string.pattern.base': 'OTP must contain only numbers'
  })
}).unknown(true);

const resendOTPSchema = Joi.object({
  phone: Joi.string().pattern(/^[6-9]\d{9}$/).required()
}).unknown(true);

// Middleware for validation
const validateSendOTP = (req, res, next) => {
  const { error } = sendOTPSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message,
      field: error.details[0].context.label
    });
  }
  next();
};

const validateVerifyOTP = (req, res, next) => {
  const { error } = verifyOTPSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message,
      field: error.details[0].context.label
    });
  }
  next();
};

const validateResendOTP = (req, res, next) => {
  const { error } = resendOTPSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message,
      field: error.details[0].context.label
    });
  }
  next();
};

/**
 * POST /api/auth/send-otp
 * Send OTP to phone number
 * Body: { phone: "1234567890", email?: "user@example.com" }
 */
router.post('/send-otp', validateSendOTP, async (req, res) => {
  try {
    const { phone, email } = req.body;

    const result = await otpService.sendOTP(phone, email);

    return res.status(200).json({
      success: true,
      message: result.message,
      data: {
        phone: result.phone,
        // For TESTING ONLY - remove in production
        otp: result.otp
      }
    });
  } catch (error) {
    logger.error('Send OTP error:', error);
    return res.status(400).json({
      success: false,
      message: error.message || 'Failed to send OTP'
    });
  }
});

/**
 * POST /api/auth/verify-otp
 * Verify OTP
 * Body: { phone: "1234567890", otp: "123456" }
 */
router.post('/verify-otp', validateVerifyOTP, async (req, res) => {
  try {
    const { phone, otp } = req.body;

    const result = await otpService.verifyOTP(phone, otp);

    return res.status(200).json({
      success: true,
      message: result.message,
      data: {
        phone: result.phone,
        verified: true
      }
    });
  } catch (error) {
    logger.error('Verify OTP error:', error);
    const statusCode = error.message.includes('expired') ? 400 : 400;
    return res.status(statusCode).json({
      success: false,
      message: error.message || 'Failed to verify OTP'
    });
  }
});

/**
 * POST /api/auth/resend-otp
 * Resend OTP to phone number
 * Body: { phone: "1234567890" }
 */
router.post('/resend-otp', validateResendOTP, async (req, res) => {
  try {
    const { phone } = req.body;

    const result = await otpService.resendOTP(phone);

    return res.status(200).json({
      success: true,
      message: result.message,
      data: {
        phone: result.phone,
        // For TESTING ONLY - remove in production
        // otp: result.otp
      }
    });
  } catch (error) {
    logger.error('Resend OTP error:', error);
    return res.status(400).json({
      success: false,
      message: error.message || 'Failed to resend OTP'
    });
  }
});

/**
 * POST /api/auth/check-otp-status
 * Check if OTP for a phone is verified
 * Body: { phone: "1234567890" }
 */
router.post('/check-otp-status', validateResendOTP, async (req, res) => {
  try {
    const { phone } = req.body;
    const isVerified = await otpService.isVerified(phone);

    return res.status(200).json({
      success: true,
      data: {
        phone,
        verified: isVerified
      }
    });
  } catch (error) {
    logger.error('Check OTP status error:', error);
    return res.status(400).json({
      success: false,
      message: error.message || 'Failed to check OTP status'
    });
  }
});

module.exports = router;
