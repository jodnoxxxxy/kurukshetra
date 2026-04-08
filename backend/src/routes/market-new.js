const express = require('express');
const marketController = require('../controllers/market.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Market routes
router.post('/prices', authenticate, marketController.recordPrice);
router.get('/prices', marketController.getAllPrices);
router.get('/latest', marketController.getLatestPrices);
router.get('/statistics', marketController.getStatistics);
router.get('/prices/crop/:cropName', marketController.getPriceByCrop);
router.get('/trends/:cropName', marketController.getPriceTrends);
router.get('/forecast/:cropName', marketController.getPriceForecast);
router.get('/location/:location', marketController.getPricesByLocation);

module.exports = router;
