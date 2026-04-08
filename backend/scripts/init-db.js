/**
 * Quick Database Initialization Script
 * Initializes SQLite database without Prisma CLI delays
 */
const Database = require('better-sqlite3');
const path = require('path');
const bcrypt = require('bcryptjs');

const dbPath = path.join(__dirname, '../dev.db');
console.log(`📊 Initializing database at: ${dbPath}\n`);

try {
  const db = new Database(dbPath);
  
  console.log('🔄 Creating database schema...');
  
  // Enable foreign keys
  db.pragma('foreign_keys = ON');
  
  // Create tables
  const schema = `
    -- Users
    CREATE TABLE IF NOT EXISTS "User" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "email" TEXT NOT NULL UNIQUE,
      "password" TEXT NOT NULL,
      "phone" TEXT,
      "firstName" TEXT,
      "lastName" TEXT,
      "role" TEXT NOT NULL DEFAULT 'FARMER',
      "profileImage" TEXT,
      "location" TEXT,
      "latitude" REAL,
      "longitude" REAL,
      "verified" BOOLEAN NOT NULL DEFAULT 0,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "deletedAt" DATETIME
    );
    
    CREATE INDEX IF NOT EXISTS "User_email_idx" on "User"("email");
    CREATE INDEX IF NOT EXISTS "User_role_idx" on "User"("role");
    
    -- User Preferences
    CREATE TABLE IF NOT EXISTS "UserPreferences" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "userId" TEXT NOT NULL UNIQUE,
      "weatherAlerts" BOOLEAN NOT NULL DEFAULT 1,
      "diseaseAlerts" BOOLEAN NOT NULL DEFAULT 1,
      "priceAlerts" BOOLEAN NOT NULL DEFAULT 1,
      "recommendationAlerts" BOOLEAN NOT NULL DEFAULT 1,
      "language" TEXT NOT NULL DEFAULT 'en',
      "theme" TEXT NOT NULL DEFAULT 'light',
      "timezone" TEXT NOT NULL DEFAULT 'UTC',
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
    );
    
    -- Farms
    CREATE TABLE IF NOT EXISTS "Farm" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "userId" TEXT NOT NULL,
      "name" TEXT NOT NULL,
      "description" TEXT,
      "totalArea" REAL,
      "soilType" TEXT,
      "location" TEXT,
      "latitude" REAL,
      "longitude" REAL,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "deletedAt" DATETIME,
      FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
    );
    
    CREATE INDEX IF NOT EXISTS "Farm_userId_idx" on "Farm"("userId");
    
    -- Crops
    CREATE TABLE IF NOT EXISTS "Crop" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "name" TEXT NOT NULL UNIQUE,
      "scientificName" TEXT,
      "category" TEXT,
      "variety" TEXT,
      "description" TEXT,
      "growingPeriod" INTEGER,
      "minTemperature" REAL,
      "maxTemperature" REAL,
      "rainfallRequired" REAL,
      "optimalPH" REAL,
      "idealHumidity" REAL,
      "waterNeeds" REAL,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "deletedAt" DATETIME
    );
    
    CREATE INDEX IF NOT EXISTS "Crop_name_idx" on "Crop"("name");
    
    -- Fields
    CREATE TABLE IF NOT EXISTS "Field" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "farmId" TEXT NOT NULL,
      "name" TEXT NOT NULL,
      "cropId" TEXT,
      "area" REAL,
      "soilPH" REAL,
      "nitrogen" REAL,
      "phosphorus" REAL,
      "potassium" REAL,
      "soilMoisture" REAL,
      "plantedDate" DATETIME,
      "expectedHarvestDate" DATETIME,
      "harvested" BOOLEAN NOT NULL DEFAULT 0,
      "harvestDate" DATETIME,
      "yield" REAL,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("farmId") REFERENCES "Farm"("id") ON DELETE CASCADE,
      FOREIGN KEY ("cropId") REFERENCES "Crop"("id")
    );
    
    CREATE INDEX IF NOT EXISTS "Field_farmId_idx" on "Field"("farmId");
    
    -- Monitoring
    CREATE TABLE IF NOT EXISTS "Monitoring" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "fieldId" TEXT NOT NULL,
      "cropId" TEXT NOT NULL,
      "temperature" REAL,
      "humidity" REAL,
      "soilMoisture" REAL,
      "soilPH" REAL,
      "nitrogen" REAL,
      "phosphorus" REAL,
      "potassium" REAL,
      "rainfall" REAL,
      "windSpeed" REAL,
      "observations" TEXT,
      "notes" TEXT,
      "photoUrl" TEXT,
      "imageUrl" TEXT,
      "recordedBy" TEXT,
      "recordedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "deletedAt" DATETIME,
      FOREIGN KEY ("fieldId") REFERENCES "Field"("id") ON DELETE CASCADE,
      FOREIGN KEY ("cropId") REFERENCES "Crop"("id") ON DELETE CASCADE
    );
    
    CREATE INDEX IF NOT EXISTS "Monitoring_fieldId_idx" on "Monitoring"("fieldId");
    CREATE INDEX IF NOT EXISTS "Monitoring_recordedAt_idx" on "Monitoring"("recordedAt");
    
    -- Orders
    CREATE TABLE IF NOT EXISTS "Order" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "userId" TEXT NOT NULL,
      "product" TEXT NOT NULL,
      "quantity" REAL NOT NULL,
      "unit" TEXT NOT NULL DEFAULT 'kg',
      "price" REAL NOT NULL,
      "totalAmount" REAL NOT NULL,
      "status" TEXT NOT NULL DEFAULT 'PENDING',
      "paymentStatus" TEXT NOT NULL DEFAULT 'UNPAID',
      "buyerName" TEXT,
      "buyerPhone" TEXT,
      "deliveryDate" DATETIME,
      "notes" TEXT,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("userId") REFERENCES "User"("id")
    );
    
    CREATE INDEX IF NOT EXISTS "Order_userId_idx" on "Order"("userId");
    CREATE INDEX IF NOT EXISTS "Order_status_idx" on "Order"("status");
    
    -- Notifications
    CREATE TABLE IF NOT EXISTS "Notification" (
      "id" TEXT NOT NULL PRIMARY KEY,
      "userId" TEXT NOT NULL,
      "type" TEXT NOT NULL,
      "title" TEXT NOT NULL,
      "message" TEXT NOT NULL,
      "dataPayload" TEXT,
      "deepLink" TEXT,
      "imageUrl" TEXT,
      "read" BOOLEAN NOT NULL DEFAULT 0,
      "readAt" DATETIME,
      "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE
    );
    
    CREATE INDEX IF NOT EXISTS "Notification_userId_idx" on "Notification"("userId");
    CREATE INDEX IF NOT EXISTS "Notification_read_idx" on "Notification"("read");
  `;
  
  // Split and execute statements
  const statements = schema.split(';').filter(s => s.trim());
  for (const stmt of statements) {
    if (stmt.trim()) {
      db.exec(stmt);
    }
  }
  
  console.log('✅ Database schema created\n');
  
  // Seed test data
  console.log('🌱 Seeding test data...');
  const salt = bcrypt.genSaltSync(10);
  const hashedPassword = bcrypt.hashSync('password123', salt);
  
  const users = [
    { id: 'farmer1', email: 'farmer1@kurukshetra.com', password: hashedPassword, firstName: 'Rajesh', lastName: 'Kumar', phone: '9876543210', role: 'FARMER', location: 'Punjab', latitude: 31.8855, longitude: 75.7521, verified: 1 },
    { id: 'farmer2', email: 'farmer2@kurukshetra.com', password: hashedPassword, firstName: 'Priya', lastName: 'Singh', phone: '9876543211', role: 'FARMER', location: 'Haryana', latitude: 29.5673, longitude: 77.2343, verified: 1 },
    { id: 'advisor1', email: 'advisor@kurukshetra.com', password: hashedPassword, firstName: 'Dr.', lastName: 'Sharma', phone: '9876543212', role: 'ADVISOR', location: 'Delhi', verified: 1 },
    { id: 'admin1', email: 'admin@kurukshetra.com', password: hashedPassword, firstName: 'Admin', lastName: 'User', phone: '9876543213', role: 'ADMIN', verified: 1 },
  ];
  
  const insertUser = db.prepare(`
    INSERT INTO "User" (id, email, password, firstName, lastName, phone, role, location, latitude, longitude, verified)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  
  for (const user of users) {
    insertUser.run(user.id, user.email, user.password, user.firstName, user.lastName, user.phone, user.role, user.location, user.latitude, user.longitude, user.verified);
  }
  
  console.log(`✅ Created ${users.length} test users`);
  
  // Create preferences
  const insertPrefs = db.prepare(`
    INSERT INTO "UserPreferences" (id, userId, weatherAlerts, diseaseAlerts, priceAlerts, recommendationAlerts, language, theme, timezone)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  
  insertPrefs.run('pref1', 'farmer1', 1, 1, 1, 1, 'en', 'light', 'IST');
  insertPrefs.run('pref2', 'farmer2', 1, 1, 1, 1, 'hi', 'dark', 'IST');
  console.log('✅ User preferences created');
  
  db.close();
  
  console.log('\n🎉 Database initialization complete!');
  console.log('\n📝 Test Credentials:');
  console.log('========================================');
  console.log('Farmer 1: farmer1@kurukshetra.com / password123');
  console.log('Farmer 2: farmer2@kurukshetra.com / password123');
  console.log('Advisor: advisor@kurukshetra.com / password123');
  console.log('Admin: admin@kurukshetra.com / password123');
  console.log('========================================\n');
  
  process.exit(0);
} catch (error) {
  console.error('❌ Database initialization failed:', error);
  process.exit(1);
}
