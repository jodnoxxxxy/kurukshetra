/**
 * Farm Service - Direct SQLite Implementation
 */
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../../dev.db');
const db = new Database(dbPath);

class FarmService {
  // Create farm
  async createFarm(userId, farmData) {
    const { name, description, totalArea, soilType, location, latitude, longitude } = farmData;
    
    try {
      const id = require('crypto').randomUUID();
      db.prepare(`
        INSERT INTO "Farm" (id, userId, name, description, totalArea, soilType, location, latitude, longitude)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(id, userId, name, description, totalArea, soilType, location, latitude, longitude);

      return this.getFarmById(id);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get user's farms
  async getUserFarms(userId) {
    try {
      const farms = db.prepare(`
        SELECT * FROM "Farm" WHERE userId = ? AND deletedAt IS NULL
      `).all(userId);
      return farms || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get farm by ID
  async getFarmById(farmId) {
    try {
      const farm = db.prepare(`SELECT * FROM "Farm" WHERE id = ? AND deletedAt IS NULL`).get(farmId);
      if (!farm) throw new Error('Farm not found');
      return farm;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update farm
  async updateFarm(farmId, userId, farmData) {
    try {
      const farm = db.prepare(`SELECT id, userId FROM "Farm" WHERE id = ? AND deletedAt IS NULL`).get(farmId);
      if (!farm) throw new Error('Farm not found');
      if (farm.userId !== userId) throw new Error('Unauthorized');

      const setClauses = Object.keys(farmData).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(farmData);
      
      db.prepare(`UPDATE "Farm" SET ${setClauses}, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(...values, farmId);
      
      return this.getFarmById(farmId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Delete farm
  async deleteFarm(farmId, userId) {
    try {
      const farm = db.prepare(`SELECT id, userId FROM "Farm" WHERE id = ? AND deletedAt IS NULL`).get(farmId);
      if (!farm) throw new Error('Farm not found');
      if (farm.userId !== userId) throw new Error('Unauthorized');

      db.prepare(`UPDATE "Farm" SET deletedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(farmId);
      return { message: 'Farm deleted successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get farm overview with fields count
  async getFarmOverview(farmId) {
    try {
      const farm = db.prepare(`SELECT * FROM "Farm" WHERE id = ? AND deletedAt IS NULL`).get(farmId);
      if (!farm) throw new Error('Farm not found');

      const fieldsCount = db.prepare(`SELECT COUNT(*) as count FROM "Field" WHERE farmId = ?`).get(farmId).count;
      const cropsCount = db.prepare(`SELECT COUNT(*) as count FROM "Field" WHERE farmId = ? AND cropId IS NOT NULL`).get(farmId).count;

      return {
        ...farm,
        fieldsCount,
        cropsCount
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new FarmService();
