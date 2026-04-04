const { prisma } = require('../config/database');

// Sample market price data
const sampleMarketPrices = [
  {
    cropName: 'Wheat',
    variety: 'HD-2967',
    pricePerQuintal: 2200,
    mandiName: 'Delhi Mandi',
    district: 'Central Delhi',
    state: 'Delhi',
    priceDate: new Date(),
    changePercent: 2.5,
    trend: 'up',
  },
  {
    cropName: 'Rice',
    variety: 'Basmati',
    pricePerQuintal: 3800,
    mandiName: 'Karnal Mandi',
    district: 'Karnal',
    state: 'Haryana',
    priceDate: new Date(),
    changePercent: -1.2,
    trend: 'down',
  },
  {
    cropName: 'Soybean',
    variety: 'JS-335',
    pricePerQuintal: 4200,
    mandiName: 'Indore Mandi',
    district: 'Indore',
    state: 'Madhya Pradesh',
    priceDate: new Date(),
    changePercent: 0,
    trend: 'stable',
  },
  {
    cropName: 'Cotton',
    variety: 'Bt Cotton',
    pricePerQuintal: 6500,
    mandiName: 'Nagpur Mandi',
    district: 'Nagpur',
    state: 'Maharashtra',
    priceDate: new Date(),
    changePercent: 3.8,
    trend: 'up',
  },
  {
    cropName: 'Maize',
    variety: 'HQPM-7',
    pricePerQuintal: 1850,
    mandiName: 'Bangalore Mandi',
    district: 'Bangalore Urban',
    state: 'Karnataka',
    priceDate: new Date(),
    changePercent: -0.5,
    trend: 'down',
  },
];

async function seedMarketPrices() {
  try {
    console.log('🌾 Seeding market prices...');
    
    // Clear existing data
    await prisma.marketPrice.deleteMany();
    
    // Insert sample data
    await prisma.marketPrice.createMany({
      data: sampleMarketPrices,
    });
    
    console.log(`✅ Seeded ${sampleMarketPrices.length} market price records`);
  } catch (error) {
    console.error('❌ Error seeding market prices:', error);
  }
}

// Sample farmer data
const sampleFarmers = [
  {
    name: 'Ramesh Kumar',
    email: 'ramesh@example.com',
    phone: '+919876543210',
    passwordHash: '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6ukx.LjDvG', // password: password123
    location: 'Punjab',
    state: 'Punjab',
    district: 'Ludhiana',
    village: 'Doraha',
    verified: true,
    languagePreference: 'en',
  },
  {
    name: 'Sita Devi',
    email: 'sita@example.com',
    phone: '+919876543211',
    passwordHash: '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6ukx.LjDvG', // password: password123
    location: 'Uttar Pradesh',
    state: 'Uttar Pradesh',
    district: 'Varanasi',
    village: 'Sarnath',
    verified: true,
    languagePreference: 'hi',
  },
];

async function seedFarmers() {
  try {
    console.log('👨‍🌾 Seeding farmers...');
    
    // Clear existing data
    await prisma.farmer.deleteMany();
    
    // Insert sample data
    await prisma.farmer.createMany({
      data: sampleFarmers,
    });
    
    console.log(`✅ Seeded ${sampleFarmers.length} farmer records`);
  } catch (error) {
    console.error('❌ Error seeding farmers:', error);
  }
}

// Main seed function
async function main() {
  try {
    await seedFarmers();
    await seedMarketPrices();
    
    console.log('\n🎉 Database seeding completed successfully!');
    console.log('\n📝 Sample Login Credentials:');
    console.log('Email: ramesh@example.com | Password: password123');
    console.log('Email: sita@example.com | Password: password123');
    
  } catch (error) {
    console.error('❌ Error during seeding:', error);
  } finally {
    await prisma.$disconnect();
  }
}

// Run seed if called directly
if (require.main === module) {
  main();
}

module.exports = {
  seedFarmers,
  seedMarketPrices,
  main,
};
