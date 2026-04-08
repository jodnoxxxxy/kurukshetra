const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

class OrderService {
  // Create new order
  async createOrder(orderData) {
    if (!orderData.userId || !orderData.cropName || !orderData.quantity) {
      throw new Error('userId, cropName, and quantity are required');
    }

    try {
      const order = await prisma.order.create({
        data: {
          userId: orderData.userId,
          cropName: orderData.cropName,
          quantity: orderData.quantity,
          unit: orderData.unit || 'kg',
          pricePerUnit: orderData.pricePerUnit || 0,
          totalPrice: (orderData.pricePerUnit || 0) * orderData.quantity,
          description: orderData.description,
          deliveryLocation: orderData.deliveryLocation,
          status: 'PENDING',
          paymentStatus: 'UNPAID'
        },
        include: {
          user: {
            select: { firstName: true, lastName: true, phone: true, email: true }
          }
        }
      });

      return order;
    } catch (error) {
      throw new Error(`Failed to create order: ${error.message}`);
    }
  }

  // Get all orders
  async getAllOrders(filters = {}) {
    try {
      const orders = await prisma.order.findMany({
        where: { deletedAt: null, ...filters },
        include: {
          user: {
            select: { id: true, firstName: true, lastName: true, email: true }
          }
        },
        orderBy: { createdAt: 'desc' }
      });

      return orders;
    } catch (error) {
      throw new Error(`Failed to fetch orders: ${error.message}`);
    }
  }

  // Get order by ID
  async getOrderById(orderId) {
    try {
      const order = await prisma.order.findUnique({
        where: { id: orderId },
        include: {
          user: {
            select: { firstName: true, lastName: true, phone: true, email: true, location: true }
          }
        }
      });

      if (!order || order.deletedAt) {
        throw new Error('Order not found');
      }

      return order;
    } catch (error) {
      throw new Error(`Failed to fetch order: ${error.message}`);
    }
  }

  // Get orders by user
  async getOrdersByUser(userId) {
    try {
      const orders = await prisma.order.findMany({
        where: {
          userId,
          deletedAt: null
        },
        orderBy: { createdAt: 'desc' }
      });

      return orders;
    } catch (error) {
      throw new Error(`Failed to fetch user orders: ${error.message}`);
    }
  }

  // Get orders by status
  async getOrdersByStatus(status) {
    try {
      const orders = await prisma.order.findMany({
        where: {
          status,
          deletedAt: null
        },
        include: {
          user: {
            select: { firstName: true, lastName: true }
          }
        },
        orderBy: { createdAt: 'desc' }
      });

      return orders;
    } catch (error) {
      throw new Error(`Failed to fetch orders by status: ${error.message}`);
    }
  }

  // Update order
  async updateOrder(orderId, updates) {
    try {
      const order = await prisma.order.update({
        where: { id: orderId },
        data: {
          quantity: updates.quantity,
          pricePerUnit: updates.pricePerUnit,
          totalPrice: (updates.pricePerUnit || 0) * (updates.quantity || 1),
          status: updates.status,
          paymentStatus: updates.paymentStatus,
          deliveryLocation: updates.deliveryLocation,
          description: updates.description
        },
        include: {
          user: {
            select: { firstName: true, lastName: true }
          }
        }
      });

      return order;
    } catch (error) {
      throw new Error(`Failed to update order: ${error.message}`);
    }
  }

  // Soft delete order
  async deleteOrder(orderId) {
    try {
      const order = await prisma.order.update({
        where: { id: orderId },
        data: { deletedAt: new Date() }
      });

      return order;
    } catch (error) {
      throw new Error(`Failed to delete order: ${error.message}`);
    }
  }

  // Get order statistics
  async getOrderStatistics() {
    try {
      const total = await prisma.order.count({
        where: { deletedAt: null }
      });

      const byStatus = {
        PENDING: await prisma.order.count({ where: { status: 'PENDING', deletedAt: null } }),
        CONFIRMED: await prisma.order.count({ where: { status: 'CONFIRMED', deletedAt: null } }),
        DELIVERED: await prisma.order.count({ where: { status: 'DELIVERED', deletedAt: null } }),
        CANCELLED: await prisma.order.count({ where: { status: 'CANCELLED', deletedAt: null } })
      };

      const byPaymentStatus = {
        PAID: await prisma.order.count({ where: { paymentStatus: 'PAID', deletedAt: null } }),
        UNPAID: await prisma.order.count({ where: { paymentStatus: 'UNPAID', deletedAt: null } }),
        PARTIAL: await prisma.order.count({ where: { paymentStatus: 'PARTIAL', deletedAt: null } })
      };

      const totalRevenue = await prisma.order.aggregate({
        where: { status: 'DELIVERED', deletedAt: null },
        _sum: { totalPrice: true }
      });

      return {
        totalOrders: total,
        byStatus,
        byPaymentStatus,
        totalRevenue: totalRevenue._sum.totalPrice || 0
      };
    } catch (error) {
      throw new Error(`Failed to get statistics: ${error.message}`);
    }
  }

  // Search orders
  async searchOrders(query) {
    try {
      const orders = await prisma.order.findMany({
        where: {
          deletedAt: null,
          OR: [
            { cropName: { contains: query, mode: 'insensitive' } },
            { description: { contains: query, mode: 'insensitive' } },
            { deliveryLocation: { contains: query, mode: 'insensitive' } }
          ]
        },
        include: {
          user: {
            select: { firstName: true, lastName: true }
          }
        }
      });

      return orders;
    } catch (error) {
      throw new Error(`Failed to search orders: ${error.message}`);
    }
  }
}

module.exports = new OrderService();
