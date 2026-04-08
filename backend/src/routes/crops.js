const express = require('express');
const cropController = require('../controllers/crop.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Crop routes
router.post('/', authenticate, cropController.createCrop);
router.get('/', cropController.getAllCrops);
router.get('/search', cropController.searchCrops);
router.get('/name/:name', cropController.getCropByName);
router.get('/:id', cropController.getCrop);
router.get('/:id/guidelines', cropController.getGuidelines);
router.put('/:id', authenticate, cropController.updateCrop);
router.delete('/:id', authenticate, cropController.deleteCrop);
router.post('/:id/guidelines', authenticate, cropController.addGuideline);

module.exports = router;
