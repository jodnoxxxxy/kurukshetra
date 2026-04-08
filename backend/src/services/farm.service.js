const { getFirestore } = require('../config/firebase');

class FarmService {
  constructor() {
    this.db = getFirestore();
    this.farmsCollection = this.db.collection('farms');
  }

  // Create a new farm
  async createFarm(userId, farmData) {
    const { name, description, totalArea, soilType, location, latitude, longitude } = farmData;

    const farmRef = this.farmsCollection.doc();
    const farm = {
      id: farmRef.id,
      userId,
      name,
      description,
      totalArea,
      soilType,
      location,
      latitude,
      longitude,
      createdAt: new Date(),
      updatedAt: new Date(),
      deletedAt: null
    };

    await farmRef.set(farm);
    return farm;
  }

  // Get all farms for a user
  async getUserFarms(userId) {
    const snapshot = await this.farmsCollection
      .where('userId', '==', userId)
      .where('deletedAt', '==', null)
      .get();

    if (snapshot.empty) {
      return [];
    }

    const farms = snapshot.docs.map(doc => doc.data());
    
    // Fetch associated fields for each farm (if necessary, in subcollections)
    // For simplicity, we'll return the farms list first
    return farms;
  }

  // Get farm by ID
  async getFarmById(farmId) {
    const doc = await this.farmsCollection.doc(farmId).get();
    if (!doc.exists || doc.data().deletedAt !== null) {
      throw new Error('Farm not found');
    }

    const farm = doc.data();
    
    // Fetch monitoring records from subcollection
    const monitoringSnapshot = await this.farmsCollection.doc(farmId)
      .collection('monitoring')
      .orderBy('recordedAt', 'desc')
      .limit(10)
      .get();
      
    farm.monitoring = monitoringSnapshot.docs.map(m => m.data());
    
    return farm;
  }

  // Update farm
  async updateFarm(farmId, userId, updates) {
    const doc = await this.farmsCollection.doc(farmId).get();
    if (!doc.exists || doc.data().userId !== userId) {
      throw new Error('Farm not found or unauthorized');
    }

    const allowedUpdates = ['name', 'description', 'totalArea', 'soilType', 'location', 'latitude', 'longitude'];
    const updateData = { updatedAt: new Date() };

    allowedUpdates.forEach(field => {
      if (field in updates) {
        updateData[field] = updates[field];
      }
    });

    await this.farmsCollection.doc(farmId).update(updateData);
    return this.getFarmById(farmId);
  }

  // Delete farm (soft delete)
  async deleteFarm(farmId, userId) {
    const doc = await this.farmsCollection.doc(farmId).get();
    if (!doc.exists || doc.data().userId !== userId) {
      throw new Error('Farm not found or unauthorized');
    }

    await this.farmsCollection.doc(farmId).update({
      deletedAt: new Date(),
      updatedAt: new Date()
    });

    return { id: farmId, status: 'deleted' };
  }

  // Get farm overview with statistics
  async getFarmOverview(farmId) {
    const farm = await this.getFarmById(farmId);
    
    // Fetch fields for statistics
    const fieldsSnapshot = await this.farmsCollection.doc(farmId)
      .collection('fields')
      .get();
      
    const fields = fieldsSnapshot.docs.map(f => f.data());
    
    const totalFields = fields.length;
    const harvestedCount = fields.filter(f => f.harvested).length;
    const cropTypes = new Set(fields.map(f => f.cropName).filter(Boolean)).size;

    return {
      ...farm,
      statistics: {
        totalFields,
        harvestedCount,
        cropTypes
      }
    };
  }
}

module.exports = new FarmService();
