const marketService = require('../services/market.service');

class MarketController {
  // POST /api/market/prices
  async recordPrice(req, res) {
    try {
      const price = await marketService.recordPrice(req.body);

      res.status(201).json({
        success: true,
        message: 'Price recorded successfully',
        data: price
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/prices
  async getAllPrices(req, res) {
    try {
      const filters = {};
      if (req.query.cropName) {
        filters.cropName = {
          contains: req.query.cropName,
          mode: 'insensitive'
        };
      }
      if (req.query.location) {
        filters.location = req.query.location;
      }

      const prices = await marketService.getAllPrices(filters);

      res.status(200).json({
        success: true,
        data: prices
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/prices/crop/:cropName
  async getPriceByCrop(req, res) {
    try {
      const prices = await marketService.getPriceByCrop(req.params.cropName);

      res.status(200).json({
        success: true,
        data: prices
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/latest
  async getLatestPrices(req, res) {
    try {
      const limit = req.query.limit || 20;
      const prices = await marketService.getLatestPrices(parseInt(limit));

      res.status(200).json({
        success: true,
        data: prices
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/trends/:cropName
  async getPriceTrends(req, res) {
    try {
      const trends = await marketService.getPriceTrends(req.params.cropName);

      res.status(200).json({
        success: true,
        data: trends
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/forecast/:cropName
  async getPriceForecast(req, res) {
    try {
      const forecast = await marketService.getPriceForecast(req.params.cropName);

      res.status(200).json({
        success: true,
        data: forecast
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/location/:location
  async getPricesByLocation(req, res) {
    try {
      const prices = await marketService.getPricesByLocation(req.params.location);

      res.status(200).json({
        success: true,
        data: prices
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/market/statistics
  async getStatistics(req, res) {
    try {
      const stats = await marketService.getMarketStatistics();

      res.status(200).json({
        success: true,
        data: stats
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new MarketController();
