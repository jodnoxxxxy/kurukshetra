const { prisma } = require('../../config/database');

// Add Transaction (Expense / Income)
exports.addTransaction = async (req, res) => {
  try {
    const { fieldId, type, category, amount, date, description } = req.body;
    let userId = req.user?.id;
    if (!userId) userId = req.userId || 'demo_farmer_id';

    // Must validate the field belongs to user
    const field = await prisma.field.findFirst({
        where: { id: fieldId },
        include: { farm: true }
    });

    if (!field || field.farm.userId !== userId) {
        return res.status(403).json({ success: false, error: 'Unauthorized to add transaction to this crop profile' });
    }

    const transaction = await prisma.transaction.create({
        data: {
            fieldId: field.id,
            userId,
            type: type, // "expense" or "income"
            category: category,
            amount: parseFloat(amount),
            date: date ? new Date(date) : new Date(),
            description: description || ''
        }
    });

    res.status(201).json({
        success: true,
        data: transaction
    });

  } catch (error) {
    console.error('Error adding transaction:', error);
    res.status(500).json({ success: false, error: 'Failed to add transaction' });
  }
};

// Get Transactions History
exports.getTransactions = async (req, res) => {
    try {
        const { fieldId } = req.params;
        let userId = req.user?.id;
        if (!userId) userId = req.userId || 'demo_farmer_id';

        const field = await prisma.field.findFirst({
            where: { id: fieldId },
            include: { farm: true }
        });

        if (!field || field.farm.userId !== userId) {
            return res.status(403).json({ success: false, error: 'Crop profile not found or unauthorized' });
        }

        const transactions = await prisma.transaction.findMany({
            where: { fieldId },
            orderBy: { date: 'desc' }
        });

        // Summary calculation
        let totalExpense = 0;
        let totalIncome = 0;
        transactions.forEach(t => {
            if (t.type === 'expense') totalExpense += t.amount;
            if (t.type === 'income') totalIncome += t.amount;
        });

        res.status(200).json({
            success: true,
            data: transactions,
            summary: {
                totalExpense,
                totalIncome,
                profit: totalIncome - totalExpense
            }
        });

    } catch (error) {
        console.error('Error fetching transactions:', error);
        res.status(500).json({ success: false, error: 'Failed to fetch transaction history' });
    }
};

// Delete Transaction
exports.deleteTransaction = async (req, res) => {
    try {
        const { id } = req.params;
        let userId = req.user?.id;
        if (!userId) userId = req.userId || 'demo_farmer_id';

        const transaction = await prisma.transaction.findFirst({
            where: { id: id, userId }
        });

        if (!transaction) {
            return res.status(404).json({ success: false, error: 'Transaction not found' });
        }

        await prisma.transaction.delete({
            where: { id: id }
        });

        res.status(200).json({
            success: true,
            message: 'Transaction deleted successfully'
        });

    } catch (error) {
        console.error('Error deleting transaction:', error);
        res.status(500).json({ success: false, error: 'Failed to delete transaction' });
    }
};


