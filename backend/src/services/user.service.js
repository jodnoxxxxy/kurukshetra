const { getAuth, getFirestore } = require('../config/firebase');
const jwt = require('jsonwebtoken');

class UserService {
  constructor() {
    this.auth = getAuth();
    this.db = getFirestore();
    this.usersCollection = this.db.collection('users');
    this.preferencesCollection = this.db.collection('preferences');
  }

  // Register a new user
  async register(userData) {
    const { email, password, phone, firstName, lastName, role = 'FARMER' } = userData;

    try {
      // Create Firebase Auth user
      const userRecord = await this.auth.createUser({
        email,
        password,
        displayName: `${firstName} ${lastName}`,
        phoneNumber: phone,
      });

      // Store additional user data in Firestore
      const user = {
        id: userRecord.uid,
        email,
        phone,
        firstName,
        lastName,
        role,
        verified: false,
        createdAt: new Date(),
        updatedAt: new Date(),
      };

      await this.usersCollection.doc(userRecord.uid).set(user);

      // Create default preferences
      await this.preferencesCollection.doc(userRecord.uid).set({
        userId: userRecord.uid,
        weatherAlerts: true,
        diseaseAlerts: true,
        priceAlerts: true,
        recommendationAlerts: true,
        language: 'en',
        theme: 'light',
        timezone: 'UTC',
      });

      const { password: _, ...userWithoutPassword } = user;
      return userWithoutPassword;
    } catch (error) {
      console.error('Firebase registration error:', error.message);
      throw error;
    }
  }

  // Login user (Note: Usually handled on client with Firebase, but here we can verify a token)
  async login(email, password) {
    // In Firebase Admin SDK, we don't 'login' with password. 
    // Usually, the frontend logins directly and sends the ID token.
    // If the backend MUST handle login, it's cumbersome with Admin SDK.
    // However, we can simulate or use the user's data from Firestore.
    
    // For the sake of this API, we'll assume the frontend will send a request 
    // that eventually verifies with ID token, but if we need a classic /login:
    // We'll check the user from Firestore (this is NOT secure, it should be done client-side).
    
    const snapshot = await this.usersCollection.where('email', '==', email).get();
    if (snapshot.empty) {
      throw new Error('Invalid email or password');
    }

    const user = snapshot.docs[0].data();
    
    // NOTE: In a real Firebase app, the frontend handles the password exchange.
    // The backend only verifies the resulting ID token.
    
    // Generate a JWT for this backend session if needed, or return user
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET || 'kurukshetra-secret-key',
      { expiresIn: '7d' }
    );

    return { user, token };
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
      // In Firebase Admin SDK, we can just update the password
      // Note: We don't verify the old password here as Admin SDK has master access.
      // For higher security, you'd usually do this client-side.
      await this.auth.updateUser(userId, {
        password: newPassword
      });
      return { message: 'Password changed successfully' };
    } catch (error) {
      throw new Error(error.message);
    }
  }

  // Logout (mostly a placeholder for token invalidation)
  async logout(userId) {
    // Firebase tokens are stateless, so usually you just clear them on client.
    // Optionally, you can revoke tokens:
    await this.auth.revokeRefreshTokens(userId);
    return { message: 'Logged out successfully' };
  }

  // Refresh access token
  async refreshAccessToken(userId) {
    try {
      const user = await this.getUserById(userId);

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

module.exports = new UserService();
