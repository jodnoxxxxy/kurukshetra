// Warehouse Controller
const warehouseService = require('../services/warehouse.service');
const logger = require('../utils/logger');

class WarehouseController {
  /**
   * POST /api/v1/warehouse/search
   * Search for warehouses near a specific location
   */
  async searchWarehouses(req, res) {
    try {
      const { latitude, longitude, capacity, maxDistance } = req.body;

      // Validation
      if (typeof latitude !== 'number' || typeof longitude !== 'number') {
        return res.status(400).json({
          success: false,
          message: 'latitude and longitude are required and must be numbers'
        });
      }

      if (latitude < -90 || latitude > 90) {
        return res.status(400).json({
          success: false,
          message: 'latitude must be between -90 and 90'
        });
      }

      if (longitude < -180 || longitude > 180) {
        return res.status(400).json({
          success: false,
          message: 'longitude must be between -180 and 180'
        });
      }

      const warehouses = warehouseService.searchWarehouses({
        latitude,
        longitude,
        capacity,
        maxDistance: maxDistance || 50
      });

      return res.status(200).json({
        success: true,
        data: warehouses,
        count: warehouses.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Warehouse search error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error searching warehouses'
      });
    }
  }

  /**
   * POST /api/v1/warehouse/book
   * Book storage space in a warehouse
   */
  async bookStorage(req, res) {
    try {
      const { warehouseId, cropType, quantity, duration, farmerId } = req.body;

      // Validation
      if (!warehouseId || !cropType || !quantity || !duration) {
        return res.status(400).json({
          success: false,
          message: 'warehouseId, cropType, quantity, and duration are required'
        });
      }

      if (quantity < 1) {
        return res.status(400).json({
          success: false,
          message: 'Quantity must be at least 1'
        });
      }

      if (!['monthly', 'quarterly', 'yearly'].includes(duration)) {
        return res.status(400).json({
          success: false,
          message: 'Duration must be monthly, quarterly, or yearly'
        });
      }

      const booking = warehouseService.bookStorage({
        warehouseId,
        cropType,
        quantity,
        duration,
        farmerId
      });

      if (!booking.success) {
        return res.status(400).json({
          success: false,
          message: booking.message || 'Could not complete booking'
        });
      }

      return res.status(201).json({
        success: true,
        data: booking.data,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Warehouse booking error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error booking warehouse'
      });
    }
  }

  /**
   * POST /api/v1/warehouse/withdraw
   * Withdraw stored crop from warehouse
   */
  async withdrawStorage(req, res) {
    try {
      const { bookingId, quantity, date } = req.body;

      if (!bookingId || !quantity) {
        return res.status(400).json({
          success: false,
          message: 'bookingId and quantity are required'
        });
      }

      if (quantity < 1) {
        return res.status(400).json({
          success: false,
          message: 'Withdrawal quantity must be at least 1'
        });
      }

      const withdrawal = warehouseService.withdrawCrop({
        bookingId,
        quantity,
        date: date ? new Date(date) : new Date()
      });

      if (!withdrawal.success) {
        return res.status(400).json({
          success: false,
          message: withdrawal.message || 'Could not process withdrawal'
        });
      }

      return res.status(200).json({
        success: true,
        data: withdrawal.data,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Warehouse withdrawal error:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error withdrawing from warehouse'
      });
    }
  }

  /**
   * GET /api/v1/warehouse/all
   * Get list of all warehouses
   */
  async getAllWarehouses(req, res) {
    try {
      const warehouses = warehouseService.getAllWarehouses();

      return res.status(200).json({
        success: true,
        data: warehouses,
        count: warehouses.length,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching warehouses:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching warehouses'
      });
    }
  }

  /**
   * GET /api/v1/warehouse/:id
   * Get details of a specific warehouse
   */
  async getWarehouseDetails(req, res) {
    try {
      const { id } = req.params;

      if (!id) {
        return res.status(400).json({
          success: false,
          message: 'Warehouse ID is required'
        });
      }

      const warehouse = warehouseService.getWarehouseById(id);

      if (!warehouse) {
        return res.status(404).json({
          success: false,
          message: `Warehouse with ID '${id}' not found`
        });
      }

      return res.status(200).json({
        success: true,
        data: warehouse,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error fetching warehouse details:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error fetching warehouse details'
      });
    }
  }

  /**
   * GET /api/v1/warehouse/:id/availability
   * Check availability and storage capacity details
   */
  async checkAvailability(req, res) {
    try {
      const { id } = req.params;

      if (!id) {
        return res.status(400).json({
          success: false,
          message: 'Warehouse ID is required'
        });
      }

      const availability = warehouseService.checkAvailability(id);

      if (!availability) {
        return res.status(404).json({
          success: false,
          message: `Warehouse with ID '${id}' not found`
        });
      }

      return res.status(200).json({
        success: true,
        data: availability,
        timestamp: new Date().toISOString()
      });
    } catch (error) {
      logger.error('Error checking availability:', error.message);
      return res.status(500).json({
        success: false,
        message: error.message || 'Error checking availability'
      });
    }
  }
}

module.exports = new WarehouseController();
