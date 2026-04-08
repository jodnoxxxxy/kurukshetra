/**
 * Direct Database Service using better-sqlite3
 * Bypasses Prisma for faster development setup
 */
const Database = require('better-sqlite3');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const dbPath = path.join(__dirname, '../../dev.db');
console.log('📁 User Database path:', dbPath);
const db = new Database(dbPath);
db.pragma('journal_mode = WAL');

class DirectUserService {
  // Register a new user
  async register(userData) {
    const { email, password, phone, firstName, lastName, role = 'FARMER' } = userData;

    try {
      // Check if user exists
      const existingUser = db.prepare('SELECT id FROM "User" WHERE email = ?').get(email);
      if (existingUser) {
        throw new Error('User with this email already exists');
      }

      // Hash password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      // Create user
      const id = require('crypto').randomUUID();
      const stmt = db.prepare(`
        INSERT INTO "User" (id, email, password, phone, firstName, lastName, role, verified)
        VALUES (?, ?, ?, ?, ?, ?, ?, 1)
      `);
      
      stmt.run(id, email, hashedPassword, phone, firstName, lastName, role);

      return {
        id,
        email,
        firstName,
        lastName,
        role,
        createdAt: new Date()
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Login user
  async login(email, password) {
    try {
      const user = db.prepare('SELECT * FROM "User" WHERE email = ?').get(email);

      if (!user) {
        throw new Error('Invalid email or password');
      }

      // Verify password
      const isValidPassword = await bcrypt.compare(password, user.password);
      if (!isValidPassword) {
        throw new Error('Invalid email or password');
      }

      // Generate JWT
      const token = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'kurukshetra-secret-key',
        { expiresIn: '7d' }
      );

      const { password: _, ...userWithoutPassword } = user;
      return {
        user: userWithoutPassword,
        token
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get user by ID
  async getUserById(userId) {
    try {
      const user = db.prepare(`
        SELECT id, email, phone, firstName, lastName, role, verified, createdAt, updatedAt
        FROM "User" WHERE id = ?
      `).get(userId);

      if (!user) {
        throw new Error('User not found');
      }

      return user;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update user profile
  async updateProfile(userId, updates) {
    try {
      const allowedUpdates = ['firstName', 'lastName', 'phone', 'profileImage', 'location', 'latitude', 'longitude'];
      const updateData = {};
      
      allowedUpdates.forEach(field => {
        if (field in updates) {
          updateData[field] = updates[field];
        }
      });

      if (Object.keys(updateData).length === 0) {
        return this.getUserById(userId);
      }

      const setClauses = Object.keys(updateData).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(updateData);
      
      db.prepare(`UPDATE "User" SET ${setClauses}, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`).run(...values, userId);

      return this.getUserById(userId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Change password
  async changePassword(userId, oldPassword, newPassword) {
    try {
      const user = db.prepare('SELECT password FROM "User" WHERE id = ?').get(userId);

      if (!user) {
        throw new Error('User not found');
      }

      // Verify old password
      const isValidPassword = await bcrypt.compare(oldPassword, user.password);
      if (!isValidPassword) {
        throw new Error('Old password is incorrect');
      }

      // Hash new password
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(newPassword, salt);

      db.prepare('UPDATE "User" SET password = ? WHERE id = ?').run(hashedPassword, userId);

      return { message: 'Password changed successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Get user preferences
  async getUserPreferences(userId) {
    try {
      let prefs = db.prepare('SELECT * FROM "UserPreferences" WHERE userId = ?').get(userId);

      if (!prefs) {
        // Create default preferences
        const id = require('crypto').randomUUID();
        db.prepare(`
          INSERT INTO "UserPreferences" (id, userId, weatherAlerts, diseaseAlerts, priceAlerts, recommendationAlerts, language, theme, timezone)
          VALUES (?, ?, 1, 1, 1, 1, 'en', 'light', 'UTC')
        `).run(id, userId);

        prefs = db.prepare('SELECT * FROM "UserPreferences" WHERE userId = ?').get(userId);
      }

      return prefs;
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Update user preferences
  async updatePreferences(userId, preferences) {
    try {
      const existing = db.prepare('SELECT id FROM "UserPreferences" WHERE userId = ?').get(userId);

      if (!existing) {
        await this.getUserPreferences(userId);
      }

      const setClauses = Object.keys(preferences).map(key => `"${key}" = ?`).join(', ');
      const values = Object.values(preferences);

      db.prepare(`UPDATE "UserPreferences" SET ${setClauses} WHERE userId = ?`).run(...values, userId);

      return this.getUserPreferences(userId);
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Logout
  async logout(userId) {
    return { message: 'Logged out successfully' };
  }

  // Refresh token
  async refreshAccessToken(userId) {
    try {
      const user = db.prepare('SELECT id, email, role FROM "User" WHERE id = ?').get(userId);

      if (!user) {
        throw new Error('User not found');
      }

      const accessToken = jwt.sign(
        { id: user.id, email: user.email, role: user.role },
        process.env.JWT_SECRET || 'kurukshetra-secret-key',
        { expiresIn: '15m' }
      );

      const refreshToken = jwt.sign(
        { id: user.id, email: user.email, role: user.role, type: 'refresh' },
        process.env.REFRESH_TOKEN_SECRET || 'kurukshetra-refresh-secret',
        { expiresIn: '7d' }
      );

      return {
        accessToken,
        refreshToken,
        expiresIn: 900
      };
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = new DirectUserService();
