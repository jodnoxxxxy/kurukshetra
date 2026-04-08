const express = require('express');
const notificationController = require('../controllers/notification.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Notification routes
router.post('/', authenticate, notificationController.createNotification);
router.get('/', authenticate, notificationController.getUserNotifications);
router.get('/statistics', authenticate, notificationController.getStatistics);
router.put('/read-all', authenticate, notificationController.markAllAsRead);
router.post('/bulk', authenticate, notificationController.sendBulkNotification);
router.get('/:id', authenticate, notificationController.getNotification);
router.put('/:id/read', authenticate, notificationController.markAsRead);
router.delete('/:id', authenticate, notificationController.deleteNotification);
router.delete('/', authenticate, notificationController.deleteAllForUser);

module.exports = router;
