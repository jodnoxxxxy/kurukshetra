require('dotenv').config();

module.exports = {
  // Server
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: process.env.PORT || 5000,
  API_VERSION: process.env.API_VERSION || 'v1',
  
  // Database
  DATABASE_URL: process.env.DATABASE_URL,
  
  // JWT
  JWT_SECRET: process.env.JWT_SECRET,
  JWT_EXPIRE_IN: process.env.JWT_EXPIRE_IN || '7d',
  JWT_REFRESH_SECRET: process.env.JWT_REFRESH_SECRET,
  JWT_REFRESH_EXPIRE_IN: process.env.JWT_REFRESH_EXPIRE_IN || '30d',
  
  // Firebase
  FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
  FIREBASE_CLIENT_EMAIL: process.env.FIREBASE_CLIENT_EMAIL,
  FIREBASE_PRIVATE_KEY: process.env.FIREBASE_PRIVATE_KEY,
  FCM_ENABLED: !!process.env.FIREBASE_PROJECT_ID,
  
  // Redis
  REDIS_URL: process.env.REDIS_URL || 'redis://localhost:6379',
  
  // Cloudinary
  CLOUDINARY_CLOUD_NAME: process.env.CLOUDINARY_CLOUD_NAME,
  CLOUDINARY_API_KEY: process.env.CLOUDINARY_API_KEY,
  CLOUDINARY_API_SECRET: process.env.CLOUDINARY_API_SECRET,
  
  // CORS
  FRONTEND_URL: process.env.FRONTEND_URL || 'http://localhost:63783',
  
  // Rate Limiting
  RATE_LIMIT_WINDOW_MS: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 900000,
  RATE_LIMIT_MAX_REQUESTS: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  
  // Logging
  LOG_LEVEL: process.env.LOG_LEVEL || 'debug',
  
  // AI Services
  OPENAI_API_KEY: process.env.OPENAI_API_KEY,
  SOIL_ANALYSIS_URL: process.env.SOIL_ANALYSIS_URL,
  PEST_DETECTION_URL: process.env.PEST_DETECTION_URL,
  CROP_RECOMMENDATION_URL: process.env.CROP_RECOMMENDATION_URL,
  
  // File Upload
  MAX_FILE_SIZE: parseInt(process.env.MAX_FILE_SIZE) || 5242880,
  UPLOAD_PATH: process.env.UPLOAD_PATH || './uploads',
};
