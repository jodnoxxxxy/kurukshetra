const express = require('express');
const Joi = require('joi');
const diseaseController = require('../controllers/disease.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Validation schemas
const createDetectionSchema = Joi.object({
  diseaseName: Joi.string().required(),
  severity: Joi.string().valid('MILD', 'MODERATE', 'SEVERE', 'CRITICAL'),
  affectedArea: Joi.number(),
  symptoms: Joi.string(),
  treatment: Joi.string(),
  imageUrl: Joi.string(),
  detectedBy: Joi.string(),
  fieldId: Joi.string().required(),
  cropId: Joi.string().required(),
  recommendation: Joi.string()
});

const updateDetectionSchema = Joi.object({
  diseaseName: Joi.string(),
  severity: Joi.string().valid('MILD', 'MODERATE', 'SEVERE', 'CRITICAL'),
  affectedArea: Joi.number(),
  symptoms: Joi.string(),
  treatment: Joi.string(),
  imageUrl: Joi.string(),
  recommendation: Joi.string()
});

const searchSchema = Joi.object({
  startDate: Joi.date().required(),
  endDate: Joi.date().required(),
  fieldId: Joi.string(),
  cropId: Joi.string(),
  severity: Joi.string()
});

// Middleware for validation
const validateCreateDetection = (req, res, next) => {
  const { error } = createDetectionSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

const validateUpdateDetection = (req, res, next) => {
  const { error } = updateDetectionSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

const validateSearch = (req, res, next) => {
  const { error } = searchSchema.validate(req.body);
  if (error) return res.status(400).json({ message: error.details[0].message });
  next();
};

// Routes
router.post('/', authenticate, diseaseController.createDetection);
router.post('/search', authenticate, diseaseController.searchByDateRange);
router.get('/statistics', diseaseController.getStatistics);
router.get('/high-severity', diseaseController.getHighSeverity);
router.get('/field/:fieldId', diseaseController.getByField);
router.get('/crop/:cropId', diseaseController.getByCrop);
router.get('/name/:diseaseName', diseaseController.getByDiseaseName);
router.get('/treatment/:diseaseName', diseaseController.getTreatments);
router.get('/', diseaseController.getAllDetections);
router.get('/:id', diseaseController.getDetection);
router.put('/:id', authenticate, diseaseController.updateDetection);
router.delete('/:id', authenticate, diseaseController.deleteDetection);

module.exports = router;
