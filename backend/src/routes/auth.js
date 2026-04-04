const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Joi = require('joi');

const config = require('../config');
const { prisma } = require('../config/database');

// Validation schemas
const registerSchema = Joi.object({
  name: Joi.string().required(),
  email: Joi.string().allow('').optional(),
  phone: Joi.string().required(),
  password: Joi.string().min(6).required(),
  district: Joi.string().required(),
  taluka: Joi.string().allow('').optional(),
  village: Joi.string().allow('').optional(),
}).unknown(true);

const loginSchema = Joi.object({
  email: Joi.string().allow('').optional(),
  phone: Joi.string().optional(),
  password: Joi.string().required(),
}).or('email', 'phone');

// POST /api/v1/auth/register
router.post('/register', async (req, res) => {
  try {
    // Validate input
    const { error } = registerSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        status: 'error',
        message: error.details[0].message,
      });
    }

    const { name, email, phone, password, district, taluka, village } = req.body;

    // Check if phone already exists
    const existingUser = await prisma.farmer.findFirst({
      where: {
        OR: [
          { phone: phone },
          { email: email || 'never_match_empty' }
        ]
      },
    });

    if (existingUser) {
      return res.status(400).json({
        status: 'error',
        message: 'Phone number or email already registered',
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);

    // Create user
    const farmer = await prisma.farmer.create({
      data: {
        name,
        email: email || `farmer_${phone}@kurukshetra.local`,
        phone,
        passwordHash,
        location: `${district}, ${taluka}, ${village}`,
        state: district,
        district,
        village,
      },
      select: {
        id: true,
        name: true,
        email: true,
        phone: true,
        verified: true,
      },
    });

    // Generate JWT token
    const token = jwt.sign(
      { id: farmer.id, email: farmer.email, phone: farmer.phone },
      config.JWT_SECRET,
      { expiresIn: config.JWT_EXPIRE_IN }
    );

    res.status(201).json({
      status: 'success',
      data: {
        farmer,
        token,
      },
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to register user',
    });
  }
});

// POST /api/v1/auth/login
router.post('/login', async (req, res) => {
  try {
    // Validate input
    const { error } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        status: 'error',
        message: error.details[0].message,
      });
    }

    const { email, phone, password } = req.body;

    // Find user
    const farmer = await prisma.farmer.findFirst({
      where: {
        OR: [
          email ? { email } : null,
          phone ? { phone } : null,
        ].filter(Boolean),
      },
    });

    if (!farmer) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials',
      });
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, farmer.passwordHash);

    if (!isPasswordValid) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials',
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: farmer.id, email: farmer.email, phone: farmer.phone },
      config.JWT_SECRET,
      { expiresIn: config.JWT_EXPIRE_IN }
    );

    res.status(200).json({
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
    console.error('Login error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to login',
    });
  }
});

module.exports = router;
