const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { prisma } = require('../config/database');

// GET /api/v1/farmers/profile
router.get('/profile', authenticate, async (req, res) => {
  try {
    const farmer = await prisma.farmer.findUnique({
      where: { id: req.user.id },
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        location: true,
        state: true,
        district: true,
        village: true,
        verified: true,
        languagePreference: true,
        createdAt: true,
      },
    });

    if (!farmer) {
      return res.status(404).json({
        status: 'error',
        message: 'Farmer not found',
      });
    }

    res.status(200).json({
      status: 'success',
      data: { farmer },
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch profile',
    });
  }
});

// PUT /api/v1/farmers/profile
router.put('/profile', authenticate, async (req, res) => {
  try {
    const { name, phone, location, state, district, village, languagePreference } = req.body;

    const updatedFarmer = await prisma.farmer.update({
      where: { id: req.user.id },
      data: {
        ...(name && { name }),
        ...(phone && { phone }),
        ...(location && { location }),
        ...(state && { state }),
        ...(district && { district }),
        ...(village && { village }),
        ...(languagePreference && { languagePreference }),
      },
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        location: true,
        state: true,
        district: true,
        village: true,
        verified: true,
        languagePreference: true,
        updatedAt: true,
      },
    });

    res.status(200).json({
      status: 'success',
      data: { farmer: updatedFarmer },
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to update profile',
    });
  }
});

// GET /api/v1/farmers/farms
router.get('/farms', authenticate, async (req, res) => {
  try {
    const farms = await prisma.farm.findMany({
      where: { farmerId: req.user.id },
      include: {
        crops: {
          select: {
            id: true,
            cropName: true,
            variety: true,
            status: true,
            plantingDate: true,
            expectedHarvest: true,
          },
        },
      },
    });

    res.status(200).json({
      status: 'success',
      data: { farms },
    });
  } catch (error) {
    console.error('Get farms error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch farms',
    });
  }
});

// POST /api/v1/farmers/farms
router.post('/farms', authenticate, async (req, res) => {
  try {
    const { farmName, locationName, latitude, longitude, areaAcres, soilType, irrigationSource } = req.body;

    const farm = await prisma.farm.create({
      data: {
        farmerId: req.user.id,
        farmName,
        locationName,
        latitude,
        longitude,
        areaAcres,
        soilType,
        irrigationSource,
      },
    });

    res.status(201).json({
      status: 'success',
      data: { farm },
    });
  } catch (error) {
    console.error('Create farm error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to create farm',
    });
  }
});

// PUT /api/v1/farmers/farms/:farmId
router.put('/farms/:farmId', authenticate, async (req, res) => {
  try {
    const { farmId } = req.params;
    const { farmName, locationName, latitude, longitude, areaAcres, soilType, irrigationSource } = req.body;

    // Verify farm belongs to user
    const existingFarm = await prisma.farm.findFirst({
      where: { id: farmId, farmerId: req.user.id },
    });

    if (!existingFarm) {
      return res.status(404).json({
        status: 'error',
        message: 'Farm not found',
      });
    }

    const updatedFarm = await prisma.farm.update({
      where: { id: farmId },
      data: {
        ...(farmName && { farmName }),
        ...(locationName && { locationName }),
        ...(latitude && { latitude }),
        ...(longitude && { longitude }),
        ...(areaAcres && { areaAcres }),
        ...(soilType && { soilType }),
        ...(irrigationSource && { irrigationSource }),
      },
    });

    res.status(200).json({
      status: 'success',
      data: { farm: updatedFarm },
    });
  } catch (error) {
    console.error('Update farm error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to update farm',
    });
  }
});

// DELETE /api/v1/farmers/farms/:farmId
router.delete('/farms/:farmId', authenticate, async (req, res) => {
  try {
    const { farmId } = req.params;

    // Verify farm belongs to user
    const existingFarm = await prisma.farm.findFirst({
      where: { id: farmId, farmerId: req.user.id },
    });

    if (!existingFarm) {
      return res.status(404).json({
        status: 'error',
        message: 'Farm not found',
      });
    }

    await prisma.farm.delete({
      where: { id: farmId },
    });

    res.status(200).json({
      status: 'success',
      message: 'Farm deleted successfully',
    });
  } catch (error) {
    console.error('Delete farm error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to delete farm',
    });
  }
});

module.exports = router;
