const express = require('express');
const router = express.Router();
const Joi = require('joi');

const farmController = require('../controllers/farm.controller');
const { authenticate } = require('../middleware/auth');

// Validation schemas
const createFarmSchema = Joi.object({
  name: Joi.string().required(),
  description: Joi.string().allow('').optional(),
  totalArea: Joi.number().positive().required(),
  soilType: Joi.string().allow('').optional(),
  location: Joi.string().allow('').optional(),
  latitude: Joi.number().optional(),
  longitude: Joi.number().optional()
}).unknown(true);

const updateFarmSchema = Joi.object({
  name: Joi.string().optional(),
  description: Joi.string().allow('').optional(),
  totalArea: Joi.number().positive().optional(),
  soilType: Joi.string().allow('').optional(),
  location: Joi.string().allow('').optional(),
  latitude: Joi.number().optional(),
  longitude: Joi.number().optional()
}).unknown(true);

// Validation middleware
const validateCreateFarm = (req, res, next) => {
  const { error } = createFarmSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message
    });
  }
  next();
};

const validateUpdateFarm = (req, res, next) => {
  const { error } = updateFarmSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      message: error.details[0].message
    });
  }
  next();
};

// Routes
router.use(authenticate); // All routes require authentication

router.post('/', validateCreateFarm, farmController.createFarm);
router.get('/', farmController.getUserFarms);
router.get('/:farmId', farmController.getFarm);
router.put('/:farmId', validateUpdateFarm, farmController.updateFarm);
router.delete('/:farmId', farmController.deleteFarm);
router.get('/:farmId/overview', farmController.getFarmOverview);

module.exports = router;
