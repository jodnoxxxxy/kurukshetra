const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

class NotificationService {
  // Create notification
  async createNotification(data) {
    if (!data.userId || !data.title) {
      throw new Error('userId and title are required');
    }

    try {
      const notification = await prisma.notification.create({
        data: {
          userId: data.userId,
          title: data.title,
          message: data.message,
          type: data.type || 'INFO',
          read: false,
          link: data.link,
          imageUrl: data.imageUrl
        }
      });

      return notification;
    } catch (error) {
      throw new Error(`Failed to create notification: ${error.message}`);
    }
  }

  // Get all notifications for user
  async getUserNotifications(userId, unreadOnly = false) {
    try {
      const notifications = await prisma.notification.findMany({
        where: {
          userId,
          ...(unreadOnly && { read: false })
        },
        orderBy: { createdAt: 'desc' }
      });

      return notifications;
    } catch (error) {
      throw new Error(`Failed to fetch notifications: ${error.message}`);
    }
  }

  // Get notification by ID
  async getNotificationById(notificationId) {
    try {
      const notification = await prisma.notification.findUnique({
        where: { id: notificationId }
      });

      if (!notification) {
        throw new Error('Notification not found');
      }

      return notification;
    } catch (error) {
      throw new Error(`Failed to fetch notification: ${error.message}`);
    }
  }

  // Mark notification as read
  async markAsRead(notificationId) {
    try {
      const notification = await prisma.notification.update({
        where: { id: notificationId },
        data: { read: true, readAt: new Date() }
      });

      return notification;
    } catch (error) {
      throw new Error(`Failed to update notification: ${error.message}`);
    }
  }

  // Mark all as read for user
  async markAllAsRead(userId) {
    try {
      const result = await prisma.notification.updateMany({
        where: {
          userId,
          read: false
        },
        data: {
          read: true,
          readAt: new Date()
        }
      });

      return { updated: result.count };
    } catch (error) {
      throw new Error(`Failed to mark notifications as read: ${error.message}`);
    }
  }

  // Delete notification
  async deleteNotification(notificationId) {
    try {
      const notification = await prisma.notification.delete({
        where: { id: notificationId }
      });

      return notification;
    } catch (error) {
      throw new Error(`Failed to delete notification: ${error.message}`);
    }
  }

  // Delete all notifications for user
  async deleteAllForUser(userId) {
    try {
      const result = await prisma.notification.deleteMany({
        where: { userId }
      });

      return { deleted: result.count };
    } catch (error) {
      throw new Error(`Failed to delete notifications: ${error.message}`);
    }
  }

  // Get notification statistics
  async getNotificationStatistics(userId) {
    try {
      const total = await prisma.notification.count({
        where: { userId }
      });

      const unread = await prisma.notification.count({
        where: {
          userId,
          read: false
        }
      });

      const byType = {
        INFO: await prisma.notification.count({ where: { userId, type: 'INFO' } }),
        WARNING: await prisma.notification.count({ where: { userId, type: 'WARNING' } }),
        ERROR: await prisma.notification.count({ where: { userId, type: 'ERROR' } }),
        SUCCESS: await prisma.notification.count({ where: { userId, type: 'SUCCESS' } })
      };

      return {
        total,
        unread,
        read: total - unread,
        byType
      };
    } catch (error) {
      throw new Error(`Failed to get statistics: ${error.message}`);
    }
  }

  // Send bulk notification
  async sendBulkNotification(userIds, title, message, type = 'INFO') {
    try {
      const notifications = await prisma.notification.createMany({
        data: userIds.map(userId => ({
          userId,
          title,
          message,
          type,
          read: false
        }))
      });

      return { created: notifications.count };
    } catch (error) {
      throw new Error(`Failed to send bulk notifications: ${error.message}`);
    }
  }
}

module.exports = new NotificationService();
