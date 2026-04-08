const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

/**
 * Seed database with test data
 * Run with: node prisma/seed.js
 */
async function seed() {
  console.log('🌱 Starting database seed...\n');

  try {
    // Clear existing data (optional, comment out if you want to keep data)
    console.log('Clearing existing data...');
    await prisma.notification.deleteMany();
    await prisma.order.deleteMany();
    await prisma.monitoring.deleteMany();
    await prisma.crop.deleteMany();
    await prisma.farm.deleteMany();
    await prisma.userPreferences.deleteMany();
    await prisma.user.deleteMany();

    // Create test users
    console.log('Creating test users...');
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('password123', salt);

    const farmer1 = await prisma.user.create({
      data: {
        id: 'farmer1',
        email: 'farmer1@kurukshetra.com',
        password: hashedPassword,
        firstName: 'Rajesh',
        lastName: 'Kumar',
        phone: '9876543210',
        role: 'FARMER',
        location: 'Punjab',
        latitude: 31.8855,
        longitude: 75.7521,
        verified: true,
      },
    });

    const farmer2 = await prisma.user.create({
      data: {
        id: 'farmer2',
        email: 'farmer2@kurukshetra.com',
        password: hashedPassword,
        firstName: 'Priya',
        lastName: 'Singh',
        phone: '9876543211',
        role: 'FARMER',
        location: 'Haryana',
        latitude: 29.5673,
        longitude: 77.2343,
        verified: true,
      },
    });

    const advisor = await prisma.user.create({
      data: {
        id: 'advisor1',
        email: 'advisor@kurukshetra.com',
        password: hashedPassword,
        firstName: 'Dr.',
        lastName: 'Sharma',
        phone: '9876543212',
        role: 'ADVISOR',
        location: 'Delhi',
        verified: true,
      },
    });

    const admin = await prisma.user.create({
      data: {
        id: 'admin1',
        email: 'admin@kurukshetra.com',
        password: hashedPassword,
        firstName: 'Admin',
        lastName: 'User',
        phone: '9876543213',
        role: 'ADMIN',
        verified: true,
      },
    });

    console.log('✅ Users created');
    console.log(`   - ${farmer1.firstName} ${farmer1.lastName}`);
    console.log(`   - ${farmer2.firstName} ${farmer2.lastName}`);
    console.log(`   - ${advisor.firstName} ${advisor.lastName}`);
    console.log(`   - ${admin.firstName} (Admin)\n`);

    // Create user preferences
    console.log('Creating user preferences...');
    await prisma.userPreferences.createMany({
      data: [
        {
          userId: farmer1.id,
          weatherAlerts: true,
          diseaseAlerts: true,
          priceAlerts: true,
          recommendationAlerts: true,
          language: 'en',
          theme: 'light',
          timezone: 'IST',
        },
        {
          userId: farmer2.id,
          weatherAlerts: true,
          diseaseAlerts: true,
          priceAlerts: true,
          recommendationAlerts: true,
          language: 'hi',
          theme: 'dark',
          timezone: 'IST',
        },
      ],
    });
    console.log('✅ User preferences created\n');

    // Create farms
    console.log('Creating farms...');
    const farm1 = await prisma.farm.create({
      data: {
        userId: farmer1.id,
        name: 'Green Valley Farm',
        location: 'Mohali, Punjab',
        latitude: 30.6449,
        longitude: 76.8233,
        totalArea: 50, // hectares
        soilType: 'LOAMY',
      },
    });

    const farm2 = await prisma.farm.create({
      data: {
        userId: farmer2.id,
        name: 'Heritage Fields',
        location: 'Faridabad, Haryana',
        latitude: 28.4089,
        longitude: 77.3178,
        totalArea: 75,
        soilType: 'CLAY',
      },
    });

    console.log('✅ Farms created');
    console.log(`   - ${farm1.name}`);
    console.log(`   - ${farm2.name}\n`);

    // Create crops (master records)
    console.log('Creating crops...');
    const crop1 = await prisma.crop.create({
      data: {
        name: 'Wheat',
        scientificName: 'Triticum aestivum',
        variety: 'HD 2967',
        growingPeriod: 120,
        minTemperature: 5,
        maxTemperature: 30,
        rainfallRequired: 400,
        optimalPH: 7,
        idealHumidity: 60,
      },
    });

    const crop2 = await prisma.crop.create({
      data: {
        name: 'Rice',
        scientificName: 'Oryza sativa',
        variety: 'Basmati',
        growingPeriod: 150,
        minTemperature: 20,
        maxTemperature: 35,
        rainfallRequired: 1200,
        optimalPH: 6.5,
        idealHumidity: 70,
      },
    });

    const crop3 = await prisma.crop.create({
      data: {
        name: 'Maize',
        scientificName: 'Zea mays',
        variety: 'NK 30',
        growingPeriod: 110,
        minTemperature: 10,
        maxTemperature: 32,
        rainfallRequired: 500,
        optimalPH: 6.8,
        idealHumidity: 65,
      },
    });

    console.log('✅ Crops created');
    console.log(`   - ${crop1.name}`);
    console.log(`   - ${crop2.name}`);
    console.log(`   - ${crop3.name}\n`);

    // Create fields under farms
    console.log('Creating fields...');
    const field1 = await prisma.field.create({
      data: {
        farmId: farm1.id,
        name: 'North Field',
        cropId: crop1.id,
        area: 20,
        plantedDate: new Date('2025-10-01'),
        expectedHarvestDate: new Date('2026-03-15'),
      },
    });

    const field2 = await prisma.field.create({
      data: {
        farmId: farm1.id,
        name: 'South Field',
        cropId: crop2.id,
        area: 15,
        plantedDate: new Date('2025-06-15'),
        expectedHarvestDate: new Date('2025-11-30'),
      },
    });

    const field3 = await prisma.field.create({
      data: {
        farmId: farm2.id,
        name: 'East Field',
        cropId: crop3.id,
        area: 40,
        plantedDate: new Date('2025-05-01'),
        expectedHarvestDate: new Date('2025-10-15'),
      },
    });

    console.log('✅ Fields created');
    console.log(`   - ${field1.name}`);
    console.log(`   - ${field2.name}`);
    console.log(`   - ${field3.name}\n`);

    // Create monitoring data
    console.log('Creating monitoring data...');
    const today = new Date();
    const monitoring = await prisma.monitoring.createMany({
      data: [
        {
          fieldId: field1.id,
          cropId: crop1.id,
          temperature: 28.5,
          humidity: 65,
          soilMoisture: 45,
          soilPH: 6.8,
          nLevel: 120,
          pLevel: 40,
          kLevel: 180,
          recordedAt: new Date(today.getTime() - 24 * 60 * 60 * 1000),
        },
        {
          fieldId: field1.id,
          cropId: crop1.id,
          temperature: 29.1,
          humidity: 62,
          soilMoisture: 48,
          soilPH: 6.9,
          nLevel: 125,
          pLevel: 42,
          kLevel: 185,
          recordedAt: today,
        },
      ],
    });
    console.log('✅ Monitoring data created\n');

    // Create orders
    console.log('Creating orders...');
    const order1 = await prisma.order.create({
      data: {
        userId: farmer1.id,
        product: 'Wheat',
        quantity: 500,
        unit: 'kg',
        price: 2500,
        totalAmount: 1250000,
        status: 'PENDING',
        paymentStatus: 'UNPAID',
        buyerName: 'Buyer 1',
        buyerPhone: '9999999999',
      },
    });

    const order2 = await prisma.order.create({
      data: {
        userId: farmer2.id,
        product: 'Maize',
        quantity: 1000,
        unit: 'kg',
        price: 2000,
        totalAmount: 2000000,
        status: 'CONFIRMED',
        paymentStatus: 'PAID',
        buyerName: 'Buyer 2',
        buyerPhone: '8888888888',
      },
    });

    console.log('✅ Orders created');
    console.log(`   - ${order1.product}: ${order1.quantity}${order1.unit}`);
    console.log(`   - ${order2.product}: ${order2.quantity}${order2.unit}\n`);

    // Create notifications
    console.log('Creating notifications...');
    await prisma.notification.createMany({
      data: [
        {
          userId: farmer1.id,
          title: 'Weather Alert',
          message: 'Heavy rainfall expected in next 48 hours',
          type: 'WEATHER_ALERT',
          read: false,
        },
        {
          userId: farmer1.id,
          title: 'Crop Disease Alert',
          message: 'Possible fungal infection detected in wheat field',
          type: 'DISEASE_ALERT',
          read: false,
        },
        {
          userId: farmer2.id,
          title: 'Price Update',
          message: 'Maize prices have increased by 5%',
          type: 'PRICE_ALERT',
          read: true,
        },
      ],
    });
    console.log('✅ Notifications created\n');

    console.log('🎉 Database seeding completed successfully!');
    console.log('\n📝 Test Credentials:');
    console.log('========================================');
    console.log('Farmer 1:');
    console.log('  Email: farmer1@kurukshetra.com');
    console.log('  Password: password123');
    console.log('\nFarmer 2:');
    console.log('  Email: farmer2@kurukshetra.com');
    console.log('  Password: password123');
    console.log('\nAdvisor:');
    console.log('  Email: advisor@kurukshetra.com');
    console.log('  Password: password123');
    console.log('\nAdmin:');
    console.log('  Email: admin@kurukshetra.com');
    console.log('  Password: password123');
    console.log('========================================');
  } catch (error) {
    console.error('❌ Error during seeding:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// Run seed
seed();
