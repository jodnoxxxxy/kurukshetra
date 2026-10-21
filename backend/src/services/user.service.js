const { getFirestore } = require('../config/firebase');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

class UserService {
  constructor() {
    this.db = getFirestore();
    this.usersCollection = this.db.collection('users');
    this.preferencesCollection = this.db.collection('preferences');
  }

  // Register a new user
  async register(userData) {
    const { name, password, phone, location, role = 'FARMER' } = userData;

    try {
      // 1. Check if user already exists
      const existingUser = await this.usersCollection.doc(phone).get();
      if (existingUser.exists) {
        throw new Error('User with this phone number already exists.');
      }

      // 2. Hash password securely
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      // 3. Store additional user data in Firestore
      const user = {
        name,
        phone,
        password: hashedPassword,
        location: location || {},
        role,
        verified: true, // They verified via OTP before calling this endpoint
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      // 4. Save to Firestore using phone as docId logic
      await this.usersCollection.doc(phone).set(user);

      // 5. Create default preferences
      await this.preferencesCollection.doc(phone).set({
        userId: phone,
        weatherAlerts: true,
        diseaseAlerts: true,
        priceAlerts: true,
        recommendationAlerts: true,
        language: 'en',
        theme: 'light',
        timezone: 'UTC',
      });

      const { password: _, ...userWithoutPassword } = user;
      userWithoutPassword.id = phone;
      return userWithoutPassword;
    } catch (error) {
      console.error('Registration error:', error.message);
      throw error;
    }
  }

  // Login user via phone + password
  async login(phone, password) {
    try {
      // 1. Check if user exists
      const snapshot = await this.usersCollection.doc(phone).get();
      
      if (!snapshot.exists) {
        throw new Error('User not found');
      }

      const user = snapshot.data();
      user.id = phone; // Attach ID context helper

      // 2. Safely compare password
      const passwordMatches = await bcrypt.compare(password, user.password);
      
      if (!passwordMatches) {
        throw new Error('Wrong password');
      }

      // 3. Generate a JWT for this backend session
      const token = jwt.sign(
        { id: user.id, phone: user.phone, role: user.role },
        process.env.JWT_SECRET || 'kurukshetra-secret-key',
        { expiresIn: '7d' }
      );

      const { password: _, ...secureUser } = user;
      return { user: secureUser, token };
    } catch (error) {
      throw error;
    }
  }

  // Get user by ID
  async getUserById(userId) {
    const doc = await this.usersCollection.doc(userId).get();
    if (!doc.exists) {
      throw new Error('User not found');
    }
    return doc.data();
  }

  // Update user profile
  async updateProfile(userId, updates) {
    const allowedUpdates = [
      'firstName',
      'lastName',
      'phone',
      'profileImage',
      'location',
      'latitude',
      'longitude'
    ];

    const updateData = { updatedAt: new Date() };
    allowedUpdates.forEach(field => {
      if (field in updates) {
        updateData[field] = updates[field];
      }
    });

    await this.usersCollection.doc(userId).update(updateData);
    return this.getUserById(userId);
  }

  // Get user preferences
  async getUserPreferences(userId) {
    const doc = await this.preferencesCollection.doc(userId).get();
    if (!doc.exists) {
      return this.updatePreferences(userId, {
        weatherAlerts: true,
        diseaseAlerts: true,
        priceAlerts: true,
        recommendationAlerts: true,
        language: 'en',
        theme: 'light',
        timezone: 'UTC'
      });
    }
    return doc.data();
  }

  // Update user preferences
  async updatePreferences(userId, preferences) {
    await this.preferencesCollection.doc(userId).set({
      userId,
      ...preferences,
      updatedAt: new Date(),
    }, { merge: true });
    
    return this.getUserPreferences(userId);
  }
  // Change password
  async changePassword(userId, oldPassword, newPassword) {
    try {
      const doc = await this.usersCollection.doc(userId).get();
      if (!doc.exists) throw new Error('User not found');
      
      const user = doc.data();
      const valid = await bcrypt.compare(oldPassword, user.password);
      if (!valid) throw new Error('Old password is incorrect');

      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(newPassword, saltRounds);

      await this.usersCollection.doc(userId).update({
        password: hashedPassword,
        updatedAt: new Date().toISOString()
      });
      
      return { message: 'Password changed successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Logout (mostly a placeholder for token invalidation)
  async logout(userId) {
    // In a pure JWT system, the client deletes the token. 
    return { message: 'Logged out successfully' };
  }

  // Refresh access token
  async refreshAccessToken(userId) {
    try {
      const user = await this.getUserById(userId);

      const accessToken = jwt.sign(
        { id: userId, phone: user.phone, role: user.role },
        process.env.JWT_SECRET || 'kurukshetra-secret-key',
        { expiresIn: '15m' }
      );

      const refreshToken = jwt.sign(
        { id: userId, phone: user.phone, role: user.role, type: 'refresh' },
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

module.exports = new UserService();
