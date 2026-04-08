const farmService = require('../services/farm.direct');

class FarmController {
  // POST /api/farms
  async createFarm(req, res) {
    try {
      const farm = await farmService.createFarm(req.user.id, req.body);

      res.status(201).json({
        success: true,
        message: 'Farm created successfully',
        data: farm
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/farms
  async getUserFarms(req, res) {
    try {
      const farms = await farmService.getUserFarms(req.user.id);

      res.status(200).json({
        success: true,
        data: farms
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/farms/:farmId
  async getFarm(req, res) {
    try {
      const farm = await farmService.getFarmById(req.params.farmId);

      res.status(200).json({
        success: true,
        data: farm
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/farms/:farmId
  async updateFarm(req, res) {
    try {
      const farm = await farmService.updateFarm(req.params.farmId, req.user.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Farm updated successfully',
        data: farm
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/farms/:farmId
  async deleteFarm(req, res) {
    try {
      await farmService.deleteFarm(req.params.farmId, req.user.id);

      res.status(200).json({
        success: true,
        message: 'Farm deleted successfully'
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/farms/:farmId/overview
  async getFarmOverview(req, res) {
    try {
      const overview = await farmService.getFarmOverview(req.params.farmId);

      res.status(200).json({
        success: true,
        data: overview
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new FarmController();
