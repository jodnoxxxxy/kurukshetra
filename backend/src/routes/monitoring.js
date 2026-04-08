const express = require('express');
const Joi = require('joi');
const monitoringController = require('../controllers/monitoring.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Validation schemas
const createMonitoringSchema = Joi.object({
  temperature: Joi.number().required(),
  humidity: Joi.number().required(),
  soilMoisture: Joi.number().required(),
  soilPH: Joi.number(),
  nLevel: Joi.number(),
  pLevel: Joi.number(),
  kLevel: Joi.number(),
  observations: Joi.string(),
  fieldId: Joi.string().required(),
  cropId: Joi.string().required(),
  recordedBy: Joi.string()
});

const updateMonitoringSchema = Joi.object({
  temperature: Joi.number(),
  humidity: Joi.number(),
  soilMoisture: Joi.number(),
  soilPH: Joi.number(),
  nLevel: Joi.number(),
  pLevel: Joi.number(),
  kLevel: Joi.number(),
  observations: Joi.string(),
  recordedBy: Joi.string()
});

const searchSchema = Joi.object({
  startDate: Joi.date().required(),
  endDate: Joi.date().required(),
  fieldId: Joi.string(),
  cropId: Joi.string()
});

// Middleware for validation
const validateCreateMonitoring = (req, res, next) => {
  const { error } = createMonitoringSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

const validateUpdateMonitoring = (req, res, next) => {
  const { error } = updateMonitoringSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

const validateSearch = (req, res, next) => {
  const { error } = searchSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Routes
router.post('/', authenticate, monitoringController.createMonitoring);
router.post('/search', authenticate, monitoringController.searchByDateRange);
router.get('/statistics/:fieldId', monitoringController.getStatistics);
router.get('/alerts/:fieldId', monitoringController.getAlerts);
router.get('/field/:fieldId', monitoringController.getByField);
router.get('/crop/:cropId', monitoringController.getByCrop);
router.get('/', monitoringController.getAllMonitoring);
router.get('/:id', monitoringController.getMonitoring);
router.put('/:id', authenticate, monitoringController.updateMonitoring);
router.delete('/:id', authenticate, monitoringController.deleteMonitoring);

module.exports = router;
