const diseaseService = require('../services/disease.service');

class DiseaseDetectionController {
  // POST /api/diseases
  async createDetection(req, res) {
    try {
      const detection = await diseaseService.createDetection(req.body);

      res.status(201).json({
        success: true,
        message: 'Disease detection recorded successfully',
        data: detection
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases
  async getAllDetections(req, res) {
    try {
      const filters = {
        fieldId: req.query.fieldId,
        cropId: req.query.cropId,
        severity: req.query.severity
      };

      const detections = await diseaseService.getAllDetections(filters);

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/:id
  async getDetection(req, res) {
    try {
      const detection = await diseaseService.getDetectionById(req.params.id);

      res.status(200).json({
        success: true,
        data: detection
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/field/:fieldId
  async getByField(req, res) {
    try {
      const detections = await diseaseService.getDetectionsByField(req.params.fieldId);

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/crop/:cropId
  async getByCrop(req, res) {
    try {
      const detections = await diseaseService.getDetectionsByCrop(req.params.cropId);

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/diseases/:id
  async updateDetection(req, res) {
    try {
      const detection = await diseaseService.updateDetection(req.params.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Disease detection updated successfully',
        data: detection
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/diseases/:id
  async deleteDetection(req, res) {
    try {
      await diseaseService.deleteDetection(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Disease detection deleted successfully'
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/high-severity
  async getHighSeverity(req, res) {
    try {
      const detections = await diseaseService.getHighSeverityDetections();

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/name/:diseaseName
  async getByDiseaseName(req, res) {
    try {
      const detections = await diseaseService.getDetectionsByDiseaseName(req.params.diseaseName);

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/diseases/statistics
  async getStatistics(req, res) {
    try {
      const stats = await diseaseService.getDiseaseStatistics();

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

  // GET /api/diseases/treatment/:diseaseName
  async getTreatments(req, res) {
    try {
      const treatments = await diseaseService.getRecommendedTreatments(req.params.diseaseName);

      res.status(200).json({
        success: true,
        data: treatments
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/diseases/search
  async searchByDateRange(req, res) {
    try {
      const { startDate, endDate, fieldId, cropId, severity } = req.body;

      if (!startDate || !endDate) {
        return res.status(400).json({
          success: false,
          message: 'startDate and endDate are required'
        });
      }

      const detections = await diseaseService.searchByDateRange(
        startDate,
        endDate,
        { fieldId, cropId, severity }
      );

      res.status(200).json({
        success: true,
        data: detections
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new DiseaseDetectionController();
