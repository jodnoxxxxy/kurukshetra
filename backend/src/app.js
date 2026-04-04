const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const http = require('http');
const { Server } = require('socket.io');

const config = require('./config');
const { connectDB } = require('./config/database');
const logger = require('./utils/logger');

// Import routes
const authRoutes = require('./routes/auth');
const farmerRoutes = require('./routes/farmers');
const marketRoutes = require('./routes/market');
const aiRoutes = require('./routes/ai');
const chatRoutes = require('./routes/chat');

// Import socket handlers
const { initializeSocket } = require('./sockets');

// Create Express app
const app = express();

// Create HTTP server
const server = http.createServer(app);

// Security middleware
app.use(helmet());

// CORS configuration
const allowedOrigins = [
  ...((config.FRONTEND_URL || '').split(',').map(o => o.trim())),
  'http://localhost:50042',
  'http://localhost:63783',
  'http://localhost:3000',
  'http://localhost:56493',
  'http://127.0.0.1:50042',
  'http://127.0.0.1:63783',
].filter(Boolean);

app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps or curl)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.indexOf(origin) !== -1 || origin.startsWith('http://localhost:')) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Compression middleware
app.use(compression());

// Logging middleware
if (config.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', { stream: logger.stream }));
}

// Rate limiting
const limiter = rateLimit({
  windowMs: config.RATE_LIMIT_WINDOW_MS,
  max: config.RATE_LIMIT_MAX_REQUESTS,
  message: {
    status: 'error',
    message: 'Too many requests from this IP, please try again later.',
  },
});
app.use('/api/', limiter);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    message: 'Kurukshetra Backend API is running',
    timestamp: new Date().toISOString(),
    environment: config.NODE_ENV,
  });
});

// API Routes
app.use(`/api/${config.API_VERSION}/auth`, authRoutes);
app.use(`/api/${config.API_VERSION}/farmers`, farmerRoutes);
app.use(`/api/${config.API_VERSION}/market`, marketRoutes);
app.use(`/api/${config.API_VERSION}/ai`, aiRoutes);
app.use(`/api/${config.API_VERSION}/chat`, chatRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found',
  });
});

// Global error handler
app.use((err, req, res, next) => {
  logger.error('Global error:', err);
  
  res.status(err.status || 500).json({
    status: 'error',
    message: config.NODE_ENV === 'development' ? err.message : 'Internal server error',
    ...(config.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

// Initialize Socket.IO
initializeSocket(server);

// Start server
async function startServer() {
  try {
    // Connect to database
    await connectDB();
    
    // Start listening
    server.listen(config.PORT, () => {
      logger.info(`🚀 Kurukshetra Backend Server`);
      logger.info(`📍 Environment: ${config.NODE_ENV}`);
      logger.info(`🌐 Port: ${config.PORT}`);
      logger.info(`⏰ Time: ${new Date().toLocaleString()}`);
      logger.info(``);
      logger.info(`API Endpoints:`);
      logger.info(`  Health: http://localhost:${config.PORT}/health`);
      logger.info(`  Auth:   http://localhost:${config.PORT}/api/${config.API_VERSION}/auth`);
      logger.info(`  Farmers: http://localhost:${config.PORT}/api/${config.API_VERSION}/farmers`);
      logger.info(`  Market: http://localhost:${config.PORT}/api/${config.API_VERSION}/market`);
      logger.info(`  AI:     http://localhost:${config.PORT}/api/${config.API_VERSION}/ai`);
      logger.info(`  Chat:   http://localhost:${config.PORT}/api/${config.API_VERSION}/chat`);
      logger.info(``);
      logger.info(`WebSocket: ws://localhost:${config.PORT}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(async () => {
    logger.info('HTTP server closed');
    await require('./config/database').disconnectDB();
    process.exit(0);
  });
});

module.exports = { app, server, startServer };
