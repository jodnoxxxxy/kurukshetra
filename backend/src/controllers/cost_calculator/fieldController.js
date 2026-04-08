const { prisma } = require('../../config/database');

// Field (Crop Profile) Management
exports.createField = async (req, res) => {
  try {
    const { name, cropName, area, season, year } = req.body;
    let userId = req.user?.id;
    
    // Mock user handling if token is bypassed
    if (!userId) {
       userId = req.userId || 'demo_farmer_id'; // Fallback
    }

    // Step 1: Ensure user has a Farm
    let farm = await prisma.farm.findFirst({
        where: { userId }
    });

    if (!farm) {
        farm = await prisma.farm.create({
            data: {
                userId,
                name: 'My Default Farm',
                totalArea: area || 10,
            }
        });
    }

    // Step 2: Ensure crop exists
    let crop = null;
    if (cropName) {
        crop = await prisma.crop.findFirst({
            where: { name: cropName }
        });
        if (!crop) {
            crop = await prisma.crop.create({
                data: {
                    name: cropName,
                    category: 'Generated',
                }
            });
        }
    }

    // Step 3: Create the Field
    const field = await prisma.field.create({
        data: {
            farmId: farm.id,
            cropId: crop?.id,
            name: name || `${cropName || 'Crop'} - ${season || ''} ${year || ''}`,
            area: area || 1,
            season: season,
            year: parseInt(year, 10),
            harvested: false
        },
        include: {
            crop: true
        }
    });

    res.status(201).json({
      success: true,
      data: field
    });
  } catch (error) {
    console.error('Error creating field:', error);
    res.status(500).json({ success: false, error: 'Failed to initialize crop profile' });
  }
};

// Get user fields
exports.getFields = async (req, res) => {
    try {
        let userId = req.user?.id;
        if (!userId) userId = req.userId || 'demo_farmer_id';

        const farms = await prisma.farm.findMany({
            where: { userId },
            include: {
                fields: {
                    include: {
                        crop: true
                    },
                    orderBy: {
                        createdAt: 'desc'
                    }
                }
            }
        });

        // Flatten fields
        const allFields = farms.map(farm => farm.fields).flat();

        res.status(200).json({
            success: true,
            data: allFields
        });
    } catch (error) {
        console.error('Error getting fields:', error);
        res.status(500).json({ success: false, error: 'Failed to fetch crop profiles' });
    }
};

// Get Dashboard Summary
exports.getFieldDashboard = async (req, res) => {
    try {
        const { fieldId } = req.params;
        let userId = req.user?.id;
        if (!userId) userId = req.userId || 'demo_farmer_id';

        const field = await prisma.field.findFirst({
            where: { id: fieldId },
            include: {
                crop: true,
                transactions: true
            }
        });

        if (!field) {
            return res.status(404).json({ success: false, error: 'Crop profile not found' });
        }

        let totalExpense = 0;
        let totalIncome = 0;

        field.transactions.forEach(t => {
            if (t.type === 'expense') totalExpense += t.amount;
            if (t.type === 'income') totalIncome += t.amount;
        });

        res.status(200).json({
            success: true,
            data: {
                field,
                summary: {
                    totalExpense,
                    totalIncome,
                    profit: totalIncome - totalExpense
                }
            }
        });

    } catch (error) {
        console.error('Error fetching dashboard:', error);
        res.status(500).json({ success: false, error: 'Failed to get dashboard summary' });
    }
};

module.exports = { createField, getFields, getFieldDashboard };
