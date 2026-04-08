/**
 * Crop Service - Direct SQLite Implementation
 */
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../../dev.db');
const db = new Database(dbPath);

class CropService {
  // Create crop
  async createCrop(cropData) {
    const { name, category, variety, description, growingPeriod, minTemp, maxTemp, optimalPH } = cropData;
    
    try {
      const id = require('crypto').randomUUID();
      db.prepare(`
        INSERT INTO "Crop" (id, name, category, variety, description, growingPeriod, minTemperature, maxTemperature, optimalPH)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `).run(id, name, category, variety, description, growingPeriod, minTemp, maxTemp, optimalPH);

      return this.getCropById(id);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get all crops
  async getAllCrops() {
    try {
      const crops = db.prepare(`SELECT * FROM "Crop" WHERE deletedAt IS NULL`).all();
      return crops || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get crop by ID
  async getCropById(cropId) {
    try {
      const crop = db.prepare(`SELECT * FROM "Crop" WHERE id = ? AND deletedAt IS NULL`).get(cropId);
      if (!crop) throw new Error('Crop not found');
      return crop;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update crop
  async updateCrop(cropId, cropData) {
    try {
      const existing = db.prepare(`SELECT id FROM "Crop" WHERE id = ? AND deletedAt IS NULL`).get(cropId);
      if (!existing) throw new Error('Crop not found');

      const setClauses = Object.keys(cropData).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(cropData);
      
      db.prepare(`UPDATE "Crop" SET ${setClauses}, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(...values, cropId);
      
      return this.getCropById(cropId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Delete crop
  async deleteCrop(cropId) {
    try {
      const crop = db.prepare(`SELECT id FROM "Crop" WHERE id = ? AND deletedAt IS NULL`).get(cropId);
      if (!crop) throw new Error('Crop not found');

      db.prepare(`UPDATE "Crop" SET deletedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(cropId);
      return { message: 'Crop deleted successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Search crops
  async searchCrops(query) {
    try {
      const crops = db.prepare(`
        SELECT * FROM "Crop" 
        WHERE deletedAt IS NULL 
        AND (name LIKE ? OR category LIKE ? OR variety LIKE ?)
      `).all(`%${query}%`, `%${query}%`, `%${query}%`);
      return crops || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new CropService();
