// backend/src/routes/pest-detection.js

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const pestService = require('../services/pest.service');
const logger = require('../utils/logger');

// Validation schemas
const imageAnalysisSchema = Joi.object({
  crop: Joi.string().required(),
  image: Joi.string().optional(),
  symptoms: Joi.array().items(Joi.string()).optional()
});

const treatmentPlanSchema = Joi.object({
  diseaseId: Joi.string().required(),
  farmSize: Joi.number().min(0.01).max(1000).optional(),
  budget: Joi.number().min(0).optional()
});

/**
 * POST /api/v1/pest-detection/analyze
 * Analyze image for disease detection
 */
router.post('/analyze', async (req, res) => {
  try {
    const { error } = imageAnalysisSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = pestService.analyzeImage(req.body);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Disease detection error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error analyzing image'
    });
  }
});

/**
 * GET /api/v1/pest-detection/disease/:diseaseId
 * Get detailed disease information
 */
router.get('/disease/:diseaseId', async (req, res) => {
  try {
    const { diseaseId } = req.params;

    const disease = Object.values(pestService.DISEASE_DATABASE).find(
      d => d.id === diseaseId || d.name.toLowerCase() === diseaseId.toLowerCase()
    );

    if (!disease) {
      return res.status(404).json({
        success: false,
        message: `Disease '${diseaseId}' not found`
      });
    }

    return res.status(200).json({
      success: true,
      data: disease,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching disease info:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching disease information'
    });
  }
});

/**
 * POST /api/v1/pest-detection/treatment-plan
 * Generate treatment plan for disease
 */
router.post('/treatment-plan', async (req, res) => {
  try {
    const { error } = treatmentPlanSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }

    const result = pestService.getTreatmentPlan(req.body.diseaseId, req.body);

    return res.status(200).json({
      success: true,
      data: result,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Treatment plan error:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error generating treatment plan'
    });
  }
});

/**
 * GET /api/v1/pest-detection/diseases
 * Get list of all known diseases
 */
router.get('/diseases', async (req, res) => {
  try {
    const diseases = Object.values(pestService.DISEASE_DATABASE).map(disease => ({
      id: disease.id,
      name: disease.name,
      crops: disease.crops,
      severity: disease.severity,
      commonSymptoms: disease.symptoms.slice(0, 3)
    }));

    return res.status(200).json({
      success: true,
      data: diseases,
      count: diseases.length,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    logger.error('Error fetching diseases list:', err.message);
    return res.status(400).json({
      success: false,
      message: err.message || 'Error fetching diseases'
    });
  }
});

module.exports = router;
