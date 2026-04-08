const notificationService = require('../services/notification.service');

class NotificationController {
  // POST /api/notifications
  async createNotification(req, res) {
    try {
      const notification = await notificationService.createNotification(req.body);

      res.status(201).json({
        success: true,
        message: 'Notification created',
        data: notification
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/notifications
  async getUserNotifications(req, res) {
    try {
      const userId = req.query.userId || req.user?.id;
      const unreadOnly = req.query.unreadOnly === 'true';

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: 'userId is required'
        });
      }

      const notifications = await notificationService.getUserNotifications(userId, unreadOnly);

      res.status(200).json({
        success: true,
        data: notifications
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/notifications/:id
  async getNotification(req, res) {
    try {
      const notification = await notificationService.getNotificationById(req.params.id);

      res.status(200).json({
        success: true,
        data: notification
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/notifications/:id/read
  async markAsRead(req, res) {
    try {
      const notification = await notificationService.markAsRead(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Notification marked as read',
        data: notification
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/notifications/read-all
  async markAllAsRead(req, res) {
    try {
      const userId = req.body.userId || req.user?.id;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: 'userId is required'
        });
      }

      const result = await notificationService.markAllAsRead(userId);

      res.status(200).json({
        success: true,
        message: 'All notifications marked as read',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/notifications/:id
  async deleteNotification(req, res) {
    try {
      await notificationService.deleteNotification(req.params.id);

      res.status(200).json({
        success: true,
        message: 'Notification deleted'
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // DELETE /api/notifications
  async deleteAllForUser(req, res) {
    try {
      const userId = req.body.userId || req.user?.id;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: 'userId is required'
        });
      }

      const result = await notificationService.deleteAllForUser(userId);

      res.status(200).json({
        success: true,
        message: 'Notifications deleted',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/notifications/statistics
  async getStatistics(req, res) {
    try {
      const userId = req.query.userId || req.user?.id;

      if (!userId) {
        return res.status(400).json({
          success: false,
          message: 'userId is required'
        });
      }

      const stats = await notificationService.getNotificationStatistics(userId);

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

  // POST /api/notifications/bulk
  async sendBulkNotification(req, res) {
    try {
      const { userIds, title, message, type } = req.body;

      if (!userIds || !Array.isArray(userIds) || !title) {
        return res.status(400).json({
          success: false,
          message: 'userIds (array) and title are required'
        });
      }

      const result = await notificationService.sendBulkNotification(userIds, title, message, type);

      res.status(201).json({
        success: true,
        message: 'Bulk notifications sent',
        data: result
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = new NotificationController();
