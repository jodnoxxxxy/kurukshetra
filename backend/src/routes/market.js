const express = require('express');
const router = express.Router();
const { prisma } = require('../config/database');

// GET /api/v1/market/prices
router.get('/prices', async (req, res) => {
  try {
    const { crop, state, district, limit = 50 } = req.query;

    const where = {};
    if (crop) where.cropName = { contains: crop, mode: 'insensitive' };
    if (state) where.state = { contains: state, mode: 'insensitive' };
    if (district) where.district = { contains: district, mode: 'insensitive' };

    const prices = await prisma.marketPrice.findMany({
      where,
      orderBy: { priceDate: 'desc' },
      take: parseInt(limit),
    });

    res.status(200).json({
      status: 'success',
      data: { prices },
    });
  } catch (error) {
    console.error('Get market prices error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch market prices',
    });
  }
});

// GET /api/v1/market/prices/nearby
router.get('/prices/nearby', async (req, res) => {
  try {
    const { lat, lng, radius = 50, limit = 20 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        status: 'error',
        message: 'Latitude and longitude are required',
      });
    }

    // For simplicity, we'll return all prices and filter by state/district
    // In a real implementation, you'd use PostGIS for geo-spatial queries
    const prices = await prisma.marketPrice.findMany({
      orderBy: { priceDate: 'desc' },
      take: parseInt(limit),
    });

    res.status(200).json({
      status: 'success',
      data: { prices },
    });
  } catch (error) {
    console.error('Get nearby prices error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch nearby prices',
    });
  }
});

// GET /api/v1/market/prices/history
router.get('/prices/history', async (req, res) => {
  try {
    const { crop, days = 30 } = req.query;

    if (!crop) {
      return res.status(400).json({
        status: 'error',
        message: 'Crop name is required',
      });
    }

    const startDate = new Date();
    startDate.setDate(startDate.getDate() - parseInt(days));

    const priceHistory = await prisma.marketPrice.findMany({
      where: {
        cropName: { contains: crop, mode: 'insensitive' },
        priceDate: { gte: startDate },
      },
      orderBy: { priceDate: 'asc' },
    });

    res.status(200).json({
      status: 'success',
      data: { 
        crop,
        history: priceHistory,
        days: parseInt(days),
      },
    });
  } catch (error) {
    console.error('Get price history error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch price history',
    });
  }
});

// GET /api/v1/market/mandis
router.get('/mandis', async (req, res) => {
  try {
    const { state } = req.query;

    const where = {};
    if (state) where.state = { contains: state, mode: 'insensitive' };

    const mandis = await prisma.marketPrice.findMany({
      where,
      select: {
        mandiName: true,
        district: true,
        state: true,
      },
      distinct: ['mandiName'],
    });

    res.status(200).json({
      status: 'success',
      data: { mandis },
    });
  } catch (error) {
    console.error('Get mandis error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch mandis',
    });
  }
});

module.exports = router;
