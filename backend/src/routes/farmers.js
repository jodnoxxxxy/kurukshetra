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

// POST /api/v1/farmers/farms/:farmId/crops
router.post('/farms/:farmId/crops', authenticate, async (req, res) => {
  try {
    let { farmId } = req.params;
    const { cropName, variety, plantingDate, expectedHarvest, areaPlanted, status } = req.body;

    // Special case for 'default' farmId to simplify frontend
    if (farmId === 'default') {
      let farm = await prisma.farm.findFirst({
        where: { farmerId: req.user.id },
      });

      if (!farm) {
        farm = await prisma.farm.create({
          data: {
            farmerId: req.user.id,
            farmName: 'My Farm',
            areaAcres: 1.0,
          },
        });
      }
      farmId = farm.id;
    }

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

    const crop = await prisma.crop.create({
      data: {
        farmId,
        cropName,
        variety,
        plantingDate: plantingDate ? new Date(plantingDate) : null,
        expectedHarvest: expectedHarvest ? new Date(expectedHarvest) : null,
        areaPlanted: parseFloat(areaPlanted) || null,
        status: status || 'planted',
      },
    });

    res.status(201).json({
      status: 'success',
      data: { crop },
    });
  } catch (error) {
    console.error('Create crop error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to create crop',
    });
  }
});

// GET /api/v1/farmers/analytics
router.get('/analytics', authenticate, async (req, res) => {
  try {
    const farms = await prisma.farm.findMany({
      where: { farmerId: req.user.id },
      include: { crops: true },
    });

    let totalCrops = 0;
    let totalArea = 0;
    let totalInvestment = 0;
    let totalSales = 0;

    farms.forEach(farm => {
      totalArea += farm.areaAcres || 0;
      totalCrops += farm.crops.length;
      
      farm.crops.forEach(crop => {
        // Mock calculations based on area
        const area = crop.areaPlanted || farm.areaAcres || 1.0;
        
        // Assume avg cost of 8,000 per acre and revenue of 15,000 per acre
        const costMultiplier = crop.cropName === 'Sugarcane' ? 15000 : 8000;
        const revenueMultiplier = crop.cropName === 'Sugarcane' ? 35000 : 18000;
        
        totalInvestment += area * costMultiplier;
        totalSales += area * revenueMultiplier;
      });
    });

    res.status(200).json({
      status: 'success',
      data: {
        totalCrops,
        totalArea,
        totalInvestment,
        totalSales,
        expectedProfit: totalSales - totalInvestment,
        organicScore: 85.5, // Mock but could be based on crop practices
      },
    });
  } catch (error) {
    console.error('Analytics error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch analytics',
    });
  }
});

// DELETE /api/v1/farmers/crops/:cropId
router.delete('/crops/:cropId', authenticate, async (req, res) => {
  try {
    const { cropId } = req.params;

    // Verify crop belongs to farm owned by user
    const crop = await prisma.crop.findFirst({
      where: { 
        id: cropId,
        farm: { farmerId: req.user.id }
      },
    });

    if (!crop) {
      return res.status(404).json({
        status: 'error',
        message: 'Crop not found',
      });
    }

    await prisma.crop.delete({
      where: { id: cropId },
    });

    res.status(200).json({
      status: 'success',
      message: 'Crop deleted successfully',
    });
  } catch (error) {
    console.error('Delete crop error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to delete crop',
    });
  }
});

// PUT /api/v1/farmers/crops/:cropId
router.put('/crops/:cropId', authenticate, async (req, res) => {
  try {
    const { cropId } = req.params;
    const { cropName, variety, plantingDate, expectedHarvest, areaPlanted, status } = req.body;

    // Verify crop belongs to farm owned by user
    const crop = await prisma.crop.findFirst({
      where: { 
        id: cropId,
        farm: { farmerId: req.user.id }
      },
    });

    if (!crop) {
      return res.status(404).json({
        status: 'error',
        message: 'Crop not found',
      });
    }

    const updatedCrop = await prisma.crop.update({
      where: { id: cropId },
      data: {
        ...(cropName && { cropName }),
        ...(variety && { variety }),
        ...(plantingDate && { plantingDate: new Date(plantingDate) }),
        ...(expectedHarvest && { expectedHarvest: new Date(expectedHarvest) }),
        ...(areaPlanted && { areaPlanted: parseFloat(areaPlanted) }),
        ...(status && { status }),
      },
    });

    res.status(200).json({
      status: 'success',
      data: { crop: updatedCrop },
    });
  } catch (error) {
    console.error('Update crop error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to update crop',
    });
  }
});

module.exports = router;
