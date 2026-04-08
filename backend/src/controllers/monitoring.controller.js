const monitoringService = require('../services/monitoring.direct');

class MonitoringController {
  // POST /api/monitoring
  async createMonitoring(req, res) {
    try {
      const monitoring = await monitoringService.createMonitoring(req.body);

      res.status(201).json({
        success: true,
        message: 'Monitoring record created successfully',
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring
  async getAllMonitoring(req, res) {
    try {
      const filters = {
        fieldId: req.query.fieldId,
        cropId: req.query.cropId,
        recordedBy: req.query.recordedBy
      };

      const monitoring = await monitoringService.getAllMonitoring(filters);

      res.status(200).json({
        success: true,
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring/:id
  async getMonitoring(req, res) {
    try {
      const monitoring = await monitoringService.getMonitoringById(req.params.id);

      res.status(200).json({
        success: true,
        data: monitoring
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring/field/:fieldId
  async getByField(req, res) {
    try {
      const limit = req.query.limit || 30;
      const monitoring = await monitoringService.getMonitoringByField(
        req.params.fieldId,
        parseInt(limit)
      );

      res.status(200).json({
        success: true,
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring/crop/:cropId
  async getByCrop(req, res) {
    try {
      const limit = req.query.limit || 30;
      const monitoring = await monitoringService.getMonitoringByCrop(
        req.params.cropId,
        parseInt(limit)
      );

      res.status(200).json({
        success: true,
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/monitoring/:id
  async updateMonitoring(req, res) {
    try {
      const monitoring = await monitoringService.updateMonitoring(req.params.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Monitoring record updated successfully',
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/monitoring/:id
  async deleteMonitoring(req, res) {
    try {
      await monitoringService.deleteMonitoring(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Monitoring record deleted successfully'
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring/statistics/:fieldId
  async getStatistics(req, res) {
    try {
      const stats = await monitoringService.getFieldStatistics(req.params.fieldId);

      res.status(200).json({
        success: true,
        data: stats
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/monitoring/alerts/:fieldId
  async getAlerts(req, res) {
    try {
      const alerts = await monitoringService.getAlertConditions(req.params.fieldId);

      res.status(200).json({
        success: true,
        data: alerts
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/monitoring/search
  async searchByDateRange(req, res) {
    try {
      const { startDate, endDate, fieldId, cropId } = req.body;

      if (!startDate || !endDate) {
        return res.status(400).json({
          success: false,
          message: 'startDate and endDate are required'
        });
      }

      const monitoring = await monitoringService.searchByDateRange(
        startDate,
        endDate,
        { fieldId, cropId }
      );

      res.status(200).json({
        success: true,
        data: monitoring
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new MonitoringController();
