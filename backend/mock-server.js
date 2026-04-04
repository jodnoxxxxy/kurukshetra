// Kurukshetra Backend - Mock Mode (No Database Required)
const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();
const PORT = 5000;

// In-memory storage
const farmers = new Map();
const jwtSecret = 'kurukshetra_dev_super_secret_jwt_key_minimum_32_chars_2024';

// Middleware
app.use(express.json());

// Ultra-permissive CORS for dev
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  res.header('Access-Control-Allow-Credentials', 'true');
  
  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

app.use(cors({
  origin: '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    message: 'Kurukshetra Backend API is running',
    timestamp: new Date().toISOString(),
    mode: 'mock (no database)',
  });
});

// Registration endpoint
app.post('/api/v1/auth/register', async (req, res) => {
  try {
    console.log('📝 Registration request received:', JSON.stringify(req.body, null, 2));
    const { name, email, phone, password, district, taluka, village, location, state } = req.body;

    // Validation
    if (!name || !phone || !password || !district) {
      console.log('❌ Validation failed:', { name: !!name, phone: !!phone, password: !!password, district: !!district });
      return res.status(400).json({
        status: 'error',
        message: 'Missing required fields: name, phone, password, district',
      });
    }

    // Check if phone already registered
    if (farmers.has(phone)) {
      return res.status(400).json({
        status: 'error',
        message: 'Phone number already registered',
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Create farmer record
    const farmerId = `farmer_${Date.now()}`;
    const farmerData = {
      id: farmerId,
      name: name.trim(),
      email: email || `${phone}@farmer.local`,
      phone: phone.trim(),
      passwordHash,
      district: district || 'Unknown',
      taluka: taluka || 'Unknown',
      village: village || 'Unknown',
      location: location || `${district}, ${taluka}, ${village}`,
      state: state || district,
      verified: false,
      createdAt: new Date().toISOString(),
    };

    // Store in memory
    farmers.set(phone, farmerData);

    // Generate JWT token
    const token = jwt.sign(
      { id: farmerId, email: farmerData.email, phone: phone },
      jwtSecret,
      { expiresIn: '7d' }
    );

    console.log(`✅ Registration successful: ${name} (${phone})`);

    res.status(201).json({
      status: 'success',
      data: {
        farmer: {
          id: farmerId,
          name: name,
          email: farmerData.email,
          phone: phone,
          verified: false,
        },
        token,
      },
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to register user: ' + error.message,
    });
  }
});

// Login endpoint
app.post('/api/v1/auth/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    if (!phone || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Phone and password required',
      });
    }

    const farmer = farmers.get(phone);
    if (!farmer) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials',
      });
    }

    const passwordMatch = await bcrypt.compare(password, farmer.passwordHash);
    if (!passwordMatch) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials',
      });
    }

    const token = jwt.sign(
      { id: farmer.id, email: farmer.email, phone: phone },
      jwtSecret,
      { expiresIn: '7d' }
    );

    res.json({
      status: 'success',
      data: {
        farmer: {
          id: farmer.id,
          name: farmer.name,
          email: farmer.email,
          phone: farmer.phone,
          verified: farmer.verified,
        },
        token,
      },
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Login failed',
    });
  }
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found',
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    status: 'error',
    message: err.message || 'Internal server error',
  });
});

// Start server
app.listen(PORT, () => {
  console.log('');
  console.log('╔════════════════════════════════════════════════════════════╗');
  console.log('║     🚀 Kurukshetra Backend - Mock Mode (No Database)      ║');
  console.log('╠════════════════════════════════════════════════════════════╣');
  console.log(`║  Port: ${PORT}                                                        ║`);
  console.log(`║  Mode: Development (In-Memory Storage)                    ║`);
  console.log(`║  Health: http://localhost:${PORT}/health                             ║`);
  console.log(`║  Register: http://localhost:${PORT}/api/v1/auth/register            ║`);
  console.log('║                                                            ║');
  console.log('║  ✅ Ready for registration testing!                      ║');
  console.log('║  ⚠️  Data lost when server restarts                      ║');
  console.log('╚════════════════════════════════════════════════════════════╝');
  console.log('');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n✋ Server shutting down...');
  process.exit(0);
});
