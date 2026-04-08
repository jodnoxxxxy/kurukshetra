const cropService = require('../services/crop.direct');

class CropController {
  // POST /api/crops
  async createCrop(req, res) {
    try {
      const crop = await cropService.createCrop(req.body);

      res.status(201).json({
        success: true,
        message: 'Crop created successfully',
        data: crop
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/crops
  async getAllCrops(req, res) {
    try {
      const crops = await cropService.getAllCrops();

      res.status(200).json({
        success: true,
        data: crops
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/crops/:id
  async getCrop(req, res) {
    try {
      const crop = await cropService.getCropById(req.params.id);

      res.status(200).json({
        success: true,
        data: crop
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/crops/:id
  async updateCrop(req, res) {
    try {
      const crop = await cropService.updateCrop(req.params.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Crop updated successfully',
        data: crop
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/crops/:id
  async deleteCrop(req, res) {
    try {
      await cropService.deleteCrop(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Crop deleted successfully'
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/crops/search?q=query
  async searchCrops(req, res) {
    try {
      const { q } = req.query;

      if (!q) {
        return res.status(400).json({
          success: false,
          message: 'Search query is required'
        });
      }

      const crops = await cropService.searchCrops(q);

      res.status(200).json({
        success: true,
        data: crops
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/crops/name/:name
  async getCropByName(req, res) {
    try {
      const crop = await cropService.getCropByName(req.params.name);

      if (!crop) {
        return res.status(404).json({
          success: false,
          message: 'Crop not found'
        });
      }

      res.status(200).json({
        success: true,
        data: crop
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/crops/guidelines/:id
  async getGuidelines(req, res) {
    try {
      const guidelines = await cropService.getGuidelines(req.params.id);

      res.status(200).json({
        success: true,
        data: guidelines
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/crops/:id/guidelines
  async addGuideline(req, res) {
    try {
      const guideline = await cropService.addGuideline(req.params.id, req.body);

      res.status(201).json({
        success: true,
        message: 'Guideline added successfully',
        data: guideline
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new CropController();
