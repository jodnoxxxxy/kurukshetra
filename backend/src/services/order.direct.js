/**
 * Order Service - Direct SQLite Implementation
 */
const Database = require('better-sqlite3');
const path = require('path');

const dbPath = path.join(__dirname, '../../dev.db');
const db = new Database(dbPath);

class OrderService {
  // Create order
  async createOrder(userId, orderData) {
    const { product, quantity, unit, price, totalAmount, buyerName, buyerPhone, notes } = orderData;
    
    try {
      const id = require('crypto').randomUUID();
      db.prepare(`
        INSERT INTO "Order" (id, userId, product, quantity, unit, price, totalAmount, buyerName, buyerPhone, notes, status, paymentStatus)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING', 'UNPAID')
      `).run(id, userId, product, quantity, unit, price, totalAmount, buyerName, buyerPhone, notes);

      return this.getOrderById(id);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get all orders (admin)
  async getAllOrders() {
    try {
      const orders = db.prepare(`SELECT * FROM "Order" ORDER BY createdAt DESC`).all();
      return orders || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get user's orders
  async getUserOrders(userId) {
    try {
      const orders = db.prepare(`
        SELECT * FROM "Order" WHERE userId = ? ORDER BY createdAt DESC
      `).all(userId);
      return orders || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get order by ID
  async getOrderById(orderId) {
    try {
      const order = db.prepare(`SELECT * FROM "Order" WHERE id = ?`).get(orderId);
      if (!order) throw new Error('Order not found');
      return order;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get orders by status
  async getOrdersByStatus(status) {
    try {
      const orders = db.prepare(`
        SELECT * FROM "Order" WHERE status = ? ORDER BY createdAt DESC
      `).all(status);
      return orders || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update order
  async updateOrder(orderId, updateData) {
    try {
      const order = db.prepare(`SELECT id FROM "Order" WHERE id = ?`).get(orderId);
      if (!order) throw new Error('Order not found');

      const setClauses = Object.keys(updateData).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(updateData);
      
      db.prepare(`UPDATE "Order" SET ${setClauses}, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(...values, orderId);
      
      return this.getOrderById(orderId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get order statistics
  async getOrderStatistics() {
    try {
      const totalOrders = db.prepare(`SELECT COUNT(*) as count FROM "Order"`).get().count;
      const pendingOrders = db.prepare(`SELECT COUNT(*) as count FROM "Order" WHERE status = 'PENDING'`).get().count;
      const confirmedOrders = db.prepare(`SELECT COUNT(*) as count FROM "Order" WHERE status = 'CONFIRMED'`).get().count;
      const deliveredOrders = db.prepare(`SELECT COUNT(*) as count FROM "Order" WHERE status = 'DELIVERED'`).get().count;
      const totalRevenue = db.prepare(`SELECT SUM(totalAmount) as total FROM "Order" WHERE paymentStatus = 'PAID'`).get().total || 0;

      return {
        totalOrders,
        pendingOrders,
        confirmedOrders,
        deliveredOrders,
        totalRevenue
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Search orders
  async searchOrders(query) {
    try {
      const orders = db.prepare(`
        SELECT * FROM "Order" 
        WHERE product LIKE ? OR buyerName LIKE ?
        ORDER BY createdAt DESC
      `).all(`%${query}%`, `%${query}%`);
      return orders || [];
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new OrderService();
