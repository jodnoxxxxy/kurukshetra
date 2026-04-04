const request = require('supertest');
const { app } = require('../src/app');

// Global test setup
beforeAll(async () => {
  // Setup test database or mocks
  console.log('Setting up test environment...');
});

afterAll(async () => {
  // Cleanup test database
  console.log('Cleaning up test environment...');
});

// Test utilities
const createTestUser = async (userData = {}) => {
  const defaultUser = {
    name: 'Test Farmer',
    email: 'test@example.com',
    phone: '+919876543210',
    password: 'password123',
    location: 'Test Location',
    state: 'Test State',
    district: 'Test District',
  };

  const response = await request(app)
    .post('/api/v1/auth/register')
    .send({ ...defaultUser, ...userData });

  return response.body;
};

const loginTestUser = async (email = 'test@example.com', password = 'password123') => {
  const response = await request(app)
    .post('/api/v1/auth/login')
    .send({ email, password });

  return response.body;
};

module.exports = {
  request,
  createTestUser,
  loginTestUser,
};
