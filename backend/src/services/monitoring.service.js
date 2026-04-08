const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

class MonitoringService {
  // Create monitoring record
  async createMonitoring(data) {
    if (!data.fieldId || !data.cropId) {
      throw new Error('fieldId and cropId are required');
    }

    try {
      const monitoring = await prisma.monitoring.create({
        data: {
          temperature: data.temperature,
          humidity: data.humidity,
          soilMoisture: data.soilMoisture,
          soilPH: data.soilPH,
          nLevel: data.nLevel || 0,
          pLevel: data.pLevel || 0,
          kLevel: data.kLevel || 0,
          observations: data.observations,
          fieldId: data.fieldId,
          cropId: data.cropId,
          recordedBy: data.recordedBy
        },
        include: {
          field: true,
          crop: true
        }
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to create monitoring record: ${error.message}`);
    }
  }

  // Get all monitoring records
  async getAllMonitoring(filters = {}) {
    try {
      const where = {};
      if (filters.fieldId) where.fieldId = filters.fieldId;
      if (filters.cropId) where.cropId = filters.cropId;
      if (filters.recordedBy) where.recordedBy = filters.recordedBy;

      const monitoring = await prisma.monitoring.findMany({
        where: { ...where, deletedAt: null },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to fetch monitoring records: ${error.message}`);
    }
  }

  // Get monitoring by ID
  async getMonitoringById(id) {
    try {
      const monitoring = await prisma.monitoring.findUnique({
        where: { id },
        include: {
          field: true,
          crop: true
        }
      });

      if (!monitoring || monitoring.deletedAt) {
        throw new Error('Monitoring record not found');
      }

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to fetch monitoring record: ${error.message}`);
    }
  }

  // Get monitoring records for a specific field
  async getMonitoringByField(fieldId, limit = 30) {
    try {
      const monitoring = await prisma.monitoring.findMany({
        where: {
          fieldId,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' },
        take: limit
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to fetch field monitoring: ${error.message}`);
    }
  }

  // Get monitoring records for a specific crop
  async getMonitoringByCrop(cropId, limit = 30) {
    try {
      const monitoring = await prisma.monitoring.findMany({
        where: {
          cropId,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' },
        take: limit
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to fetch crop monitoring: ${error.message}`);
    }
  }

  // Update monitoring record
  async updateMonitoring(id, updates) {
    try {
      const monitoring = await prisma.monitoring.update({
        where: { id },
        data: {
          temperature: updates.temperature,
          humidity: updates.humidity,
          soilMoisture: updates.soilMoisture,
          soilPH: updates.soilPH,
          nLevel: updates.nLevel,
          pLevel: updates.pLevel,
          kLevel: updates.kLevel,
          observations: updates.observations,
          recordedBy: updates.recordedBy
        },
        include: {
          field: true,
          crop: true
        }
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to update monitoring record: ${error.message}`);
    }
  }

  // Soft delete monitoring record
  async deleteMonitoring(id) {
    try {
      const monitoring = await prisma.monitoring.update({
        where: { id },
        data: { deletedAt: new Date() }
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to delete monitoring record: ${error.message}`);
    }
  }

  // Get monitoring statistics for a field
  async getFieldStatistics(fieldId) {
    try {
      const records = await prisma.monitoring.findMany({
        where: {
          fieldId,
          deletedAt: null
        }
      });

      if (records.length === 0) {
        return { message: 'No monitoring data available' };
      }

      const avgTemperature = records.reduce((sum, r) => sum + (r.temperature || 0), 0) / records.length;
      const avgHumidity = records.reduce((sum, r) => sum + (r.humidity || 0), 0) / records.length;
      const avgSoilMoisture = records.reduce((sum, r) => sum + (r.soilMoisture || 0), 0) / records.length;
      const avgSoilPH = records.reduce((sum, r) => sum + (r.soilPH || 0), 0) / records.length;

      return {
        recordCount: records.length,
        avgTemperature: Math.round(avgTemperature * 10) / 10,
        avgHumidity: Math.round(avgHumidity * 10) / 10,
        avgSoilMoisture: Math.round(avgSoilMoisture * 10) / 10,
        avgSoilPH: Math.round(avgSoilPH * 100) / 100,
        lastRecordedAt: records[0]?.createdAt
      };
    } catch (error) {
      throw new Error(`Failed to get field statistics: ${error.message}`);
    }
  }

  // Search monitoring records by date range
  async searchByDateRange(startDate, endDate, filters = {}) {
    try {
      const monitoring = await prisma.monitoring.findMany({
        where: {
          createdAt: {
            gte: new Date(startDate),
            lte: new Date(endDate)
          },
          fieldId: filters.fieldId,
          cropId: filters.cropId,
          deletedAt: null
        },
        include: {
          field: true,
          crop: true
        },
        orderBy: { createdAt: 'desc' }
      });

      return monitoring;
    } catch (error) {
      throw new Error(`Failed to search monitoring records: ${error.message}`);
    }
  }

  // Get alert-worthy conditions
  async getAlertConditions(fieldId) {
    try {
      const latestRecords = await prisma.monitoring.findMany({
        where: {
          fieldId,
          deletedAt: null
        },
        orderBy: { createdAt: 'desc' },
        take: 1
      });

      if (latestRecords.length === 0) {
        return { alerts: [] };
      }

      const record = latestRecords[0];
      const alerts = [];

      // Temperature alerts
      if (record.temperature < 10) alerts.push({ type: 'LOW_TEMPERATURE', value: record.temperature });
      if (record.temperature > 40) alerts.push({ type: 'HIGH_TEMPERATURE', value: record.temperature });

      // Humidity alerts
      if (record.humidity < 30) alerts.push({ type: 'LOW_HUMIDITY', value: record.humidity });
      if (record.humidity > 90) alerts.push({ type: 'HIGH_HUMIDITY', value: record.humidity });

      // Soil moisture alerts
      if (record.soilMoisture < 20) alerts.push({ type: 'LOW_SOIL_MOISTURE', value: record.soilMoisture });
      if (record.soilMoisture > 80) alerts.push({ type: 'HIGH_SOIL_MOISTURE', value: record.soilMoisture });

      // pH alerts
      if (record.soilPH < 6) alerts.push({ type: 'ACIDIC_SOIL', value: record.soilPH });
      if (record.soilPH > 8) alerts.push({ type: 'ALKALINE_SOIL', value: record.soilPH });

      return { alerts, lastRecordedAt: record.createdAt };
    } catch (error) {
      throw new Error(`Failed to get alert conditions: ${error.message}`);
    }
  }
}

module.exports = new MonitoringService();
