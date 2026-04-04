const request = require('supertest');
const { app } = require('../../src/app');

describe('Authentication Endpoints', () => {
  describe('POST /api/v1/auth/register', () => {
    it('should register a new farmer successfully', async () => {
      const userData = {
        name: 'John Farmer',
        email: 'john@example.com',
        phone: '+919876543210',
        password: 'password123',
        location: 'Punjab',
        state: 'Punjab',
        district: 'Ludhiana',
      };

      const response = await request(app)
        .post('/api/v1/auth/register')
        .send(userData)
        .expect(201);

      expect(response.body.status).toBe('success');
      expect(response.body.data.farmer.email).toBe(userData.email);
      expect(response.body.data.farmer.name).toBe(userData.name);
      expect(response.body.data.token).toBeDefined();
    });

    it('should return error for duplicate email', async () => {
      const userData = {
        name: 'Jane Farmer',
        email: 'john@example.com', // Same email as above
        phone: '+919876543211',
        password: 'password123',
        location: 'Punjab',
        state: 'Punjab',
        district: 'Ludhiana',
      };

      const response = await request(app)
        .post('/api/v1/auth/register')
        .send(userData)
        .expect(400);

      expect(response.body.status).toBe('error');
      expect(response.body.message).toContain('already registered');
    });

    it('should return error for invalid email', async () => {
      const userData = {
        name: 'Test Farmer',
        email: 'invalid-email',
        phone: '+919876543210',
        password: 'password123',
        location: 'Punjab',
        state: 'Punjab',
        district: 'Ludhiana',
      };

      const response = await request(app)
        .post('/api/v1/auth/register')
        .send(userData)
        .expect(400);

      expect(response.body.status).toBe('error');
      expect(response.body.message).toContain('email');
    });
  });

  describe('POST /api/v1/auth/login', () => {
    it('should login successfully with valid credentials', async () => {
      const loginData = {
        email: 'john@example.com',
        password: 'password123',
      };

      const response = await request(app)
        .post('/api/v1/auth/login')
        .send(loginData)
        .expect(200);

      expect(response.body.status).toBe('success');
      expect(response.body.data.farmer.email).toBe(loginData.email);
      expect(response.body.data.token).toBeDefined();
    });

    it('should return error for invalid credentials', async () => {
      const loginData = {
        email: 'john@example.com',
        password: 'wrongpassword',
      };

      const response = await request(app)
        .post('/api/v1/auth/login')
        .send(loginData)
        .expect(401);

      expect(response.body.status).toBe('error');
      expect(response.body.message).toContain('Invalid credentials');
    });

    it('should return error for non-existent user', async () => {
      const loginData = {
        email: 'nonexistent@example.com',
        password: 'password123',
      };

      const response = await request(app)
        .post('/api/v1/auth/login')
        .send(loginData)
        .expect(401);

      expect(response.body.status).toBe('error');
      expect(response.body.message).toContain('Invalid credentials');
    });
  });

  describe('GET /health', () => {
    it('should return health check', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body.status).toBe('ok');
      expect(response.body.timestamp).toBeDefined();
    });
  });
});
