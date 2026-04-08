/**
 * Monitoring Service - Direct SQLite Implementation
 */
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../../dev.db');
const db = new Database(dbPath);

class MonitoringService {
  // Create monitoring record
  async createMonitoring(fieldId, cropId, monitoringData) {
    const { temperature, humidity, soilMoisture, soilPH, nitrogen, phosphorus, potassium, rainfall, windSpeed, observations, recordedBy } = monitoringData;
    
    try {
      const id = require('crypto').randomUUID();
      db.prepare(`
        INSERT INTO "Monitoring" (id, fieldId, cropId, temperature, humidity, soilMoisture, soilPH, nitrogen, phosphorus, potassium, rainfall, windSpeed, observations, recordedBy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(id, fieldId, cropId, temperature, humidity, soilMoisture, soilPH, nitrogen, phosphorus, potassium, rainfall, windSpeed, observations, recordedBy);

      return this.getMonitoringById(id);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get monitoring records for field
  async getFieldMonitoring(fieldId) {
    try {
      const records = db.prepare(`
        SELECT * FROM "Monitoring" WHERE fieldId = ? AND deletedAt IS NULL ORDER BY recordedAt DESC
      `).all(fieldId);
      return records || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get monitoring records for crop
  async getCropMonitoring(cropId) {
    try {
      const records = db.prepare(`
        SELECT * FROM "Monitoring" WHERE cropId = ? AND deletedAt IS NULL ORDER BY recordedAt DESC
      `).all(cropId);
      return records || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get monitoring record by ID
  async getMonitoringById(monitoringId) {
    try {
      const record = db.prepare(`SELECT * FROM "Monitoring" WHERE id = ? AND deletedAt IS NULL`).get(monitoringId);
      if (!record) throw new Error('Monitoring record not found');
      return record;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get latest monitoring for field
  async getLatestFieldMonitoring(fieldId) {
    try {
      const record = db.prepare(`
        SELECT * FROM "Monitoring" WHERE fieldId = ? AND deletedAt IS NULL ORDER BY recordedAt DESC LIMIT 1
      `).get(fieldId);
      return record;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update monitoring record
  async updateMonitoring(monitoringId, updateData) {
    try {
      const record = db.prepare(`SELECT id FROM "Monitoring" WHERE id = ? AND deletedAt IS NULL`).get(monitoringId);
      if (!record) throw new Error('Monitoring record not found');

      const setClauses = Object.keys(updateData).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(updateData);
      
      db.prepare(`UPDATE "Monitoring" SET ${setClauses}, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(...values, monitoringId);
      
      return this.getMonitoringById(monitoringId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Delete monitoring record
  async deleteMonitoring(monitoringId) {
    try {
      const record = db.prepare(`SELECT id FROM "Monitoring" WHERE id = ? AND deletedAt IS NULL`).get(monitoringId);
      if (!record) throw new Error('Monitoring record not found');

      db.prepare(`UPDATE "Monitoring" SET deletedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(monitoringId);
      return { message: 'Monitoring record deleted successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get field statistics
  async getFieldStatistics(fieldId) {
    try {
      const records = db.prepare(`
        SELECT * FROM "Monitoring" WHERE fieldId = ? AND deletedAt IS NULL ORDER BY recordedAt DESC LIMIT 30
      `).all(fieldId);

      if (records.length === 0) return null;

      const avgTemp = (records.reduce((sum, r) => sum + (r.temperature || 0), 0) / records.length).toFixed(2);
      const avgHumidity = (records.reduce((sum, r) => sum + (r.humidity || 0), 0) / records.length).toFixed(2);
      const avgMoisture = (records.reduce((sum, r) => sum + (r.soilMoisture || 0), 0) / records.length).toFixed(2);

      return {
        totalReadings: records.length,
        averageTemp: parseFloat(avgTemp),
        averageHumidity: parseFloat(avgHumidity),
        averageMoisture: parseFloat(avgMoisture),
        latestReading: records[0]
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new MonitoringService();
