const orderService = require('../services/order.direct');

class OrderController {
  // POST /api/orders
  async createOrder(req, res) {
    try {
      const order = await orderService.createOrder(req.body);

      res.status(201).json({
        success: true,
        message: 'Order created successfully',
        data: order
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/orders
  async getAllOrders(req, res) {
    try {
      const filters = {};
      if (req.query.status) filters.status = req.query.status;
      if (req.query.paymentStatus) filters.paymentStatus = req.query.paymentStatus;

      const orders = await orderService.getAllOrders(filters);

      res.status(200).json({
        success: true,
        data: orders
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/orders/:id
  async getOrder(req, res) {
    try {
      const order = await orderService.getOrderById(req.params.id);

      res.status(200).json({
        success: true,
        data: order
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/orders/user/:userId
  async getByUser(req, res) {
    try {
      const orders = await orderService.getOrdersByUser(req.params.userId);

      res.status(200).json({
        success: true,
        data: orders
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/orders/status/:status
  async getByStatus(req, res) {
    try {
      const orders = await orderService.getOrdersByStatus(req.params.status);

      res.status(200).json({
        success: true,
        data: orders
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/orders/:id
  async updateOrder(req, res) {
    try {
      const order = await orderService.updateOrder(req.params.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Order updated successfully',
        data: order
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/orders/:id
  async deleteOrder(req, res) {
    try {
      await orderService.deleteOrder(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Order deleted successfully'
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/orders/statistics
  async getStatistics(req, res) {
    try {
      const stats = await orderService.getOrderStatistics();

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

  // GET /api/orders/search/:query
  async searchOrders(req, res) {
    try {
      const { query } = req.params;

      if (!query) {
        return res.status(400).json({
          success: false,
          message: 'Search query is required'
        });
      }

      const orders = await orderService.searchOrders(query);

      res.status(200).json({
        success: true,
        data: orders
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new OrderController();
