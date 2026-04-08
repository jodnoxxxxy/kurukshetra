const express = require('express');
const { PrismaClient } = require('@prisma/client');
const router = express.Router();
const prisma = new PrismaClient();

// Middleware for authentication
const authMiddleware = (req, res, next) => {
  const userId = req.user?.id || req.body.userId;
  if (!userId) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  req.userId = userId;
  next();
};

// ============================================================
// CREATE MANUAL CROP INSPECTION
// ============================================================
router.post('/', authMiddleware, async (req, res) => {
  try {
    const {
      fieldId,
      cropId,
      healthStatus,
      pests,
      diseases,
      leafCondition,
      soilCondition,
      cropHeight,
      leafColor,
      moistureLevel,
      wateringNeeded,
      issues,
      recommendation,
      actionRequired,
      riskLevel,
      imageUrl,
      notes,
    } = req.body;

    // Validate required fields
    if (!fieldId || !cropId) {
      return res.status(400).json({ error: 'fieldId and cropId are required' });
    }

    // Verify field and crop exist
    const field = await prisma.field.findUnique({
      where: { id: fieldId },
      include: { farm: { select: { userId: true } } },
    });

    if (!field || field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Field not found' });
    }

    const crop = await prisma.crop.findUnique({
      where: { id: cropId },
    });

    if (!crop) {
      return res.status(404).json({ error: 'Crop not found' });
    }

    // Determine risk level based on issues
    let calculatedRiskLevel = riskLevel || 'LOW';
    if (healthStatus === 'CRITICAL' || healthStatus === 'DISEASED') {
      calculatedRiskLevel = 'CRITICAL';
    } else if (healthStatus === 'STRESSED') {
      calculatedRiskLevel = 'HIGH';
    } else if (leafCondition === 'DAMAGED' || leafCondition === 'WILTING') {
      calculatedRiskLevel = 'MEDIUM';
    }

    // Create inspection record
    const inspection = await prisma.cropInspection.create({
      data: {
        fieldId,
        cropId,
        healthStatus: healthStatus || 'HEALTHY',
        pests,
        diseases,
        leafCondition,
        soilCondition,
        cropHeight: cropHeight ? parseFloat(cropHeight) : null,
        leafColor,
        moistureLevel,
        wateringNeeded: wateringNeeded || false,
        issues,
        recommendation,
        actionRequired: actionRequired || false,
        riskLevel: calculatedRiskLevel,
        imageUrl,
        inspectedBy: req.userId,
        notes,
      },
      include: {
        field: true,
        crop: true,
      },
    });

    // Generate advisory prediction if health is not optimal
    if (healthStatus !== 'HEALTHY') {
      const prediction = await prisma.prediction.create({
        data: {
          fieldId,
          cropId,
          inspectionId: inspection.id,
          type: 'INSPECTION_BASED',
          predictedValue: healthStatus === 'CRITICAL' ? 0.2 : healthStatus === 'DISEASED' ? 0.4 : 0.7,
          confidence: 0.85,
          recommendation: recommendation || 'Monitor crop closely and take appropriate action',
          factors: JSON.stringify({
            healthStatus,
            pests,
            diseases,
            leafCondition,
            soilCondition,
            moistureLevel,
          }),
        },
      });

      inspection.prediction = prediction;
    }

    res.status(201).json({
      success: true,
      data: inspection,
      message: 'Inspection recorded successfully',
    });
  } catch (error) {
    console.error('Error creating inspection:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// GET INSPECTIONS FOR A FIELD
// ============================================================
router.get('/field/:fieldId', authMiddleware, async (req, res) => {
  try {
    const { fieldId } = req.params;

    // Verify field ownership
    const field = await prisma.field.findUnique({
      where: { id: fieldId },
      include: { farm: { select: { userId: true } } },
    });

    if (!field || field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Field not found' });
    }

    const inspections = await prisma.cropInspection.findMany({
      where: { fieldId },
      include: {
        field: true,
        crop: true,
        predictions: true,
      },
      orderBy: { inspectedAt: 'desc' },
    });

    res.json({
      success: true,
      data: inspections,
      count: inspections.length,
    });
  } catch (error) {
    console.error('Error fetching inspections:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// GET LATEST INSPECTION FOR A FIELD
// ============================================================
router.get('/field/:fieldId/latest', authMiddleware, async (req, res) => {
  try {
    const { fieldId } = req.params;

    // Verify field ownership
    const field = await prisma.field.findUnique({
      where: { id: fieldId },
      include: { farm: { select: { userId: true } } },
    });

    if (!field || field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Field not found' });
    }

    const inspection = await prisma.cropInspection.findFirst({
      where: { fieldId },
      include: {
        field: true,
        crop: true,
        predictions: true,
      },
      orderBy: { inspectedAt: 'desc' },
    });

    if (!inspection) {
      return res.status(404).json({
        success: false,
        message: 'No inspections found for this field',
      });
    }

    res.json({
      success: true,
      data: inspection,
    });
  } catch (error) {
    console.error('Error fetching latest inspection:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// GET INSPECTION BY ID
// ============================================================
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;

    const inspection = await prisma.cropInspection.findUnique({
      where: { id },
      include: {
        field: {
          include: {
            farm: {
              select: { userId: true },
            },
          },
        },
        crop: true,
        predictions: true,
      },
    });

    if (!inspection || inspection.field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Inspection not found' });
    }

    res.json({
      success: true,
      data: inspection,
    });
  } catch (error) {
    console.error('Error fetching inspection:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// UPDATE INSPECTION
// ============================================================
router.put('/:id', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const {
      healthStatus,
      pests,
      diseases,
      leafCondition,
      soilCondition,
      cropHeight,
      leafColor,
      moistureLevel,
      wateringNeeded,
      issues,
      recommendation,
      actionRequired,
      riskLevel,
      imageUrl,
      notes,
    } = req.body;

    // Verify ownership
    const inspection = await prisma.cropInspection.findUnique({
      where: { id },
      include: {
        field: {
          include: {
            farm: { select: { userId: true } },
          },
        },
      },
    });

    if (!inspection || inspection.field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Inspection not found' });
    }

    // Recalculate risk level if health status changed
    let calculatedRiskLevel = riskLevel;
    if (healthStatus) {
      if (healthStatus === 'CRITICAL' || healthStatus === 'DISEASED') {
        calculatedRiskLevel = 'CRITICAL';
      } else if (healthStatus === 'STRESSED') {
        calculatedRiskLevel = 'HIGH';
      } else if (leafCondition === 'DAMAGED' || leafCondition === 'WILTING') {
        calculatedRiskLevel = 'MEDIUM';
      }
    }

    const updated = await prisma.cropInspection.update({
      where: { id },
      data: {
        healthStatus: healthStatus || undefined,
        pests: pests || undefined,
        diseases: diseases || undefined,
        leafCondition: leafCondition || undefined,
        soilCondition: soilCondition || undefined,
        cropHeight: cropHeight ? parseFloat(cropHeight) : undefined,
        leafColor: leafColor || undefined,
        moistureLevel: moistureLevel || undefined,
        wateringNeeded: wateringNeeded !== undefined ? wateringNeeded : undefined,
        issues: issues || undefined,
        recommendation: recommendation || undefined,
        actionRequired: actionRequired !== undefined ? actionRequired : undefined,
        riskLevel: calculatedRiskLevel || undefined,
        imageUrl: imageUrl || undefined,
        notes: notes || undefined,
      },
      include: {
        field: true,
        crop: true,
        predictions: true,
      },
    });

    res.json({
      success: true,
      data: updated,
      message: 'Inspection updated successfully',
    });
  } catch (error) {
    console.error('Error updating inspection:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// DELETE INSPECTION
// ============================================================
router.delete('/:id', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;

    // Verify ownership
    const inspection = await prisma.cropInspection.findUnique({
      where: { id },
      include: {
        field: {
          include: {
            farm: { select: { userId: true } },
          },
        },
      },
    });

    if (!inspection || inspection.field.farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Inspection not found' });
    }

    // Soft delete
    await prisma.cropInspection.update({
      where: { id },
      data: { deletedAt: new Date() },
    });

    res.json({
      success: true,
      message: 'Inspection deleted successfully',
    });
  } catch (error) {
    console.error('Error deleting inspection:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================================
// GET INSPECTION SUMMARY FOR A FARM
// ============================================================
router.get('/summary/farm/:farmId', authMiddleware, async (req, res) => {
  try {
    const { farmId } = req.params;

    // Verify farm ownership
    const farm = await prisma.farm.findUnique({
      where: { id: farmId },
    });

    if (!farm || farm.userId !== req.userId) {
      return res.status(404).json({ error: 'Farm not found' });
    }

    // Get all fields on the farm
    const fields = await prisma.field.findMany({
      where: { farmId },
      select: { id: true },
    });

    const fieldIds = fields.map((f) => f.id);

    // Get latest inspection for each field
    const inspections = await prisma.cropInspection.findMany({
      where: {
        fieldId: { in: fieldIds },
        deletedAt: null,
      },
      include: {
        field: { select: { id: true, name: true } },
        crop: { select: { id: true, name: true } },
      },
      orderBy: { inspectedAt: 'desc' },
    });

    // Group by field and get latest for each
    const latestByField = {};
    inspections.forEach((inspection) => {
      if (!latestByField[inspection.fieldId]) {
        latestByField[inspection.fieldId] = inspection;
      }
    });

    // Calculate summary stats
    const stats = {
      totalInspections: inspections.length,
      healthyFields: inspections.filter((i) => i.healthStatus === 'HEALTHY').length,
      stressedFields: inspections.filter((i) => i.healthStatus === 'STRESSED').length,
      diseasedFields: inspections.filter((i) => i.healthStatus === 'DISEASED').length,
      criticalFields: inspections.filter((i) => i.healthStatus === 'CRITICAL').length,
      criticalRiskCount: inspections.filter((i) => i.riskLevel === 'CRITICAL').length,
      highRiskCount: inspections.filter((i) => i.riskLevel === 'HIGH').length,
    };

    res.json({
      success: true,
      data: {
        stats,
        latestInspections: Object.values(latestByField),
      },
    });
  } catch (error) {
    console.error('Error fetching inspection summary:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
