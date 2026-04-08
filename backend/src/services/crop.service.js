const { getFirestore } = require('../config/firebase');

class CropService {
  constructor() {
    this.db = getFirestore();
    this.cropsCollection = this.db.collection('crops');
  }

  // Create a new crop
  async createCrop(cropData) {
    if (!cropData.name) {
      throw new Error('Crop name is required');
    }

    const cropRef = this.cropsCollection.doc();
    const crop = {
      id: cropRef.id,
      name: cropData.name,
      scientificName: cropData.scientificName || null,
      category: cropData.category || null,
      variety: cropData.variety || null,
      description: cropData.description || null,
      growingPeriod: cropData.growingPeriod || null,
      minTemperature: cropData.minTemperature || null,
      maxTemperature: cropData.maxTemperature || null,
      rainfallRequired: cropData.rainfallRequired || null,
      optimalPH: cropData.optimalPH || null,
      idealHumidity: cropData.idealHumidity || null,
      waterNeeds: cropData.waterNeeds || null,
      createdAt: new Date(),
      updatedAt: new Date(),
      deletedAt: null
    };

    await cropRef.set(crop);
    return crop;
  }

  // Get all crops
  async getAllCrops() {
    const snapshot = await this.cropsCollection
      .where('deletedAt', '==', null)
      .orderBy('createdAt', 'desc')
      .get();

    return snapshot.docs.map(doc => doc.data());
  }

  // Get crop by ID
  async getCropById(cropId) {
    const doc = await this.cropsCollection.doc(cropId).get();
    if (!doc.exists || doc.data().deletedAt !== null) {
      throw new Error('Crop not found');
    }

    const crop = doc.data();
    
    // Fetch guidelines from subcollection
    const guidelinesSnapshot = await this.cropsCollection.doc(cropId)
      .collection('guidelines')
      .where('deletedAt', '==', null)
      .orderBy('createdAt', 'desc')
      .get();
      
    crop.guidelines = guidelinesSnapshot.docs.map(g => g.data());
    
    return crop;
  }

  // Update crop
  async updateCrop(cropId, updates) {
    const cropRef = this.cropsCollection.doc(cropId);
    const doc = await cropRef.get();
    if (!doc.exists || doc.data().deletedAt !== null) {
      throw new Error('Crop not found');
    }

    const updateData = {
      ...updates,
      updatedAt: new Date()
    };

    await cropRef.update(updateData);
    return this.getCropById(cropId);
  }

  // Soft delete crop
  async deleteCrop(cropId) {
    await this.cropsCollection.doc(cropId).update({
      deletedAt: new Date(),
      updatedAt: new Date()
    });
    return { id: cropId, status: 'deleted' };
  }

  // Get crop by name
  async getCropByName(name) {
    const snapshot = await this.cropsCollection
      .where('name', '==', name)
      .where('deletedAt', '==', null)
      .limit(1)
      .get();

    if (snapshot.empty) {
      throw new Error('Crop not found');
    }

    return snapshot.docs[0].data();
  }

  // Search crops
  async searchCrops(query) {
    // Note: Firestore doesn't support full-text search or 'contains' natively with mode: 'insensitive'.
    // We fetch all and filter in-memory for simple search, or use a prefix search.
    // For a real app, Algolia or similar is used.
    
    const snapshot = await this.cropsCollection
      .where('deletedAt', '==', null)
      .get();
      
    const searchLower = query.toLowerCase();
    return snapshot.docs
      .map(doc => doc.data())
      .filter(crop => 
        crop.name?.toLowerCase().includes(searchLower) ||
        crop.scientificName?.toLowerCase().includes(searchLower) ||
        crop.category?.toLowerCase().includes(searchLower)
      );
  }

  // Add crop guideline
  async addGuideline(cropId, guidelineData) {
    const guidelineRef = this.cropsCollection.doc(cropId).collection('guidelines').doc();
    const guideline = {
      id: guidelineRef.id,
      cropId,
      stage: guidelineData.stage,
      action: guidelineData.action,
      duration: guidelineData.duration,
      createdAt: new Date(),
      updatedAt: new Date(),
      deletedAt: null
    };

    await guidelineRef.set(guideline);
    return guideline;
  }

  // Get crop guidelines
  async getGuidelines(cropId) {
    const snapshot = await this.cropsCollection.doc(cropId)
      .collection('guidelines')
      .where('deletedAt', '==', null)
      .orderBy('createdAt', 'desc')
      .get();

    return snapshot.docs.map(doc => doc.data());
  }
}

module.exports = new CropService();
