const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const fieldController = require('../controllers/cost_calculator/fieldController');
const transactionController = require('../controllers/cost_calculator/transactionController');

// Field Initialization & Setup
router.post('/fields', auth, fieldController.createField);
router.get('/fields', auth, fieldController.getFields);

// Dashboard Initialization
router.get('/fields/:fieldId/dashboard', auth, fieldController.getFieldDashboard);

// Transaction Entry & History
router.post('/transactions', auth, transactionController.addTransaction);
router.get('/fields/:fieldId/transactions', auth, transactionController.getTransactions);
router.delete('/transactions/:id', auth, transactionController.deleteTransaction);

module.exports = router;
