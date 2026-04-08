const express = require('express');
const router = express.Router();
const Joi = require('joi');

const authController = require('../controllers/auth.controller');
const { authenticate } = require('../middleware/auth');

// Validation schemas
const registerSchema = Joi.object({
  firstName: Joi.string().required(),
  lastName: Joi.string().required(),
  email: Joi.string().email().required(),
  phone: Joi.string().required(),
  password: Joi.string().min(6).required(),
  role: Joi.string().valid('FARMER', 'ADVISOR', 'ADMIN', 'GOVERNMENT_OFFICIAL').default('FARMER')
}).unknown(true);

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required()
}).unknown(true);

// Validation middleware
const validateRegister = (req, res, next) => {
  const { error } = registerSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message
    });
  }
  next();
};

const validateLogin = (req, res, next) => {
  const { error } = loginSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message
    });
  }
  next();
};

// Routes
router.post('/register', validateRegister, authController.register);
router.post('/login', validateLogin, authController.login);
router.post('/logout', authenticate, authController.logout);
router.post('/refresh-token', authController.refreshToken);
router.get('/profile', authenticate, authController.getProfile);
router.put('/profile', authenticate, authController.updateProfile);
router.post('/change-password', authenticate, authController.changePassword);
router.get('/preferences', authenticate, authController.getPreferences);
router.put('/preferences', authenticate, authController.updatePreferences);

module.exports = router;
