const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const climateController = require('../controllers/climate/climateController');

// GET /api/v1/climate/advisory
// Fetch real-time weather and risk analysis
router.get('/advisory', authenticate, climateController.getAdvisory);

module.exports = router;