const express = require('express');
const orderController = require('../controllers/order.controller');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Order routes
router.post('/', authenticate, orderController.createOrder);
router.get('/', orderController.getAllOrders);
router.get('/statistics', orderController.getStatistics);
router.get('/search/:query', orderController.searchOrders);
router.get('/user/:userId', orderController.getByUser);
router.get('/status/:status', orderController.getByStatus);
router.get('/:id', orderController.getOrder);
router.put('/:id', authenticate, orderController.updateOrder);
router.delete('/:id', authenticate, orderController.deleteOrder);

module.exports = router;
