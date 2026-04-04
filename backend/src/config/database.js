const { PrismaClient } = require('@prisma/client');
const config = require('./index');

let prisma;

if (config.NODE_ENV === 'production') {
  prisma = new PrismaClient();
} else {
  prisma = new PrismaClient({
    log: ['query', 'info', 'warn', 'error'],
  });
}

async function connectDB() {
  try {
    await prisma.$connect();
    console.log('✅ PostgreSQL connected successfully');
  } catch (error) {
    console.error('❌ Database connection error:', error.message);
    throw error;
  }
}

async function disconnectDB() {
  try {
    await prisma.$disconnect();
    console.log('Database disconnected');
  } catch (error) {
    console.error('Error disconnecting database:', error.message);
  }
}

module.exports = {
  prisma,
  connectDB,
  disconnectDB,
};
