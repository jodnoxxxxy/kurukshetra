const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

class DiseaseDetectionService {
  // Create disease detection record
  async createDetection(data) {
    if (!data.fieldId || !data.cropId) {
      throw new Error('fieldId and cropId are required');
    }

    try {
      const detection = await prisma.diseaseDetection.create({
        data: {
          diseaseName: data.diseaseName,
          severity: data.severity || 'MILD',
          affectedArea: data.affectedArea || 0,
          symptoms: data.symptoms,
          treatment: data.treatment,
          imageUrl: data.imageUrl,
          detectedBy: data.detectedBy,
          fieldId: data.fieldId,
          cropId: data.cropId,
          recommendation: data.recommendation
        },
        include: {
          field: true,
          crop: true
        }
      });

      return detection;
    } catch (error) {
      throw new Error(`Failed to create disease detection: ${error.message}`);
    }
  }

  // Get all disease detections
  async getAllDetections(filters = {}) {
    try {
      const where = {};
      if (filters.fieldId) where.fieldId = filters.fieldId;
      if (filters.cropId) where.cropId = filters.cropId;
      if (filters.severity) where.severity = filters.severity;

      const detections = await prisma.diseaseDetection.findMany({
        where: { ...where, deletedAt: null },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to fetch disease detections: ${error.message}`);
    }
  }

  // Get detection by ID
  async getDetectionById(id) {
    try {
      const detection = await prisma.diseaseDetection.findUnique({
        where: { id },
        include: {
          field: true,
          crop: true
        }
      });

      if (!detection || detection.deletedAt) {
        throw new Error('Disease detection record not found');
      }

      return detection;
    } catch (error) {
      throw new Error(`Failed to fetch disease detection: ${error.message}`);
    }
  }

  // Get detections by field
  async getDetectionsByField(fieldId) {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          fieldId,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to fetch field detections: ${error.message}`);
    }
  }

  // Get detections by crop
  async getDetectionsByCrop(cropId) {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          cropId,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to fetch crop detections: ${error.message}`);
    }
  }

  // Update detection record
  async updateDetection(id, updates) {
    try {
      const detection = await prisma.diseaseDetection.update({
        where: { id },
        data: {
          diseaseName: updates.diseaseName,
          severity: updates.severity,
          affectedArea: updates.affectedArea,
          symptoms: updates.symptoms,
          treatment: updates.treatment,
          imageUrl: updates.imageUrl,
          recommendation: updates.recommendation
        },
        include: {
          field: true,
          crop: true
        }
      });

      return detection;
    } catch (error) {
      throw new Error(`Failed to update disease detection: ${error.message}`);
    }
  }

  // Soft delete detection
  async deleteDetection(id) {
    try {
      const detection = await prisma.diseaseDetection.update({
        where: { id },
        data: { deletedAt: new Date() }
      });

      return detection;
    } catch (error) {
      throw new Error(`Failed to delete disease detection: ${error.message}`);
    }
  }

  // Get high severity detections
  async getHighSeverityDetections() {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          severity: { in: ['SEVERE', 'CRITICAL'] },
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to fetch high severity detections: ${error.message}`);
    }
  }

  // Get detections by disease name
  async getDetectionsByDiseaseName(diseaseName) {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          diseaseName: {
            contains: diseaseName,
            mode: 'insensitive'
          },
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to search disease detections: ${error.message}`);
    }
  }

  // Get disease statistics
  async getDiseaseStatistics() {
    try {
      const total = await prisma.diseaseDetection.count({
        where: { deletedAt: null }
      });

      const bySeverity = {
        MILD: await prisma.diseaseDetection.count({ where: { severity: 'MILD', deletedAt: null } }),
        MODERATE: await prisma.diseaseDetection.count({ where: { severity: 'MODERATE', deletedAt: null } }),
        SEVERE: await prisma.diseaseDetection.count({ where: { severity: 'SEVERE', deletedAt: null } }),
        CRITICAL: await prisma.diseaseDetection.count({ where: { severity: 'CRITICAL', deletedAt: null } })
      };

      const diseases = await prisma.diseaseDetection.findMany({
        where: { deletedAt: null },
        select: { diseaseName: true },
        distinct: ['diseaseName']
      });

      return {
        totalDetections: total,
        bySeverity,
        uniqueDiseases: diseases.length
      };
    } catch (error) {
      throw new Error(`Failed to get disease statistics: ${error.message}`);
    }
  }

  // Get recommended treatments
  async getRecommendedTreatments(diseaseName) {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          diseaseName,
          deletedAt: null,
          treatment: { not: null }
        },
        select: { treatment: true, recommendation: true },
        take: 5
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to fetch treatment recommendations: ${error.message}`);
    }
  }

  // Search detections by date range
  async searchByDateRange(startDate, endDate, filters = {}) {
    try {
      const detections = await prisma.diseaseDetection.findMany({
        where: {
          createdAt: {
            gte: new Date(startDate),
            lte: new Date(endDate)
          },
          fieldId: filters.fieldId,
          cropId: filters.cropId,
          severity: filters.severity,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return detections;
    } catch (error) {
      throw new Error(`Failed to search disease detections: ${error.message}`);
    }
  }
}

module.exports = new DiseaseDetectionService();
