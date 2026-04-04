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
  email: Joi.string().email().required(),
  phone: Joi.string().required(),
  password: Joi.string().min(6).required(),
  location: Joi.string().required(),
  state: Joi.string().required(),
  district: Joi.string().required(),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

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

    const { name, email, phone, password, location, state, district } = req.body;

    // Check if user already exists
    const existingUser = await prisma.farmer.findUnique({
      where: { email },
    });

    if (existingUser) {
      return res.status(400).json({
        status: 'error',
        message: 'Email already registered',
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);

    // Create user
    const farmer = await prisma.farmer.create({
      data: {
        name,
        email,
        phone,
        passwordHash,
        location,
        state,
        district,
      },
      select: {
        id: true,
        name: true,
        email: true,
        verified: true,
      },
    });

    // Generate JWT token
    const token = jwt.sign(
      { id: farmer.id, email: farmer.email },
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

    const { email, password } = req.body;

    // Find user
    const farmer = await prisma.farmer.findUnique({
      where: { email },
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
      { id: farmer.id, email: farmer.email },
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
