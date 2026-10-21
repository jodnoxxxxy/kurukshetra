const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const admin = require('firebase-admin');

class FirestoreUserService {
  constructor() {
    this.db = admin.firestore();
    this.auth = admin.auth();
    this.JWT_SECRET = process.env.JWT_SECRET || 'kurukshetra-secret-key-dev';
    this.REFRESH_SECRET = process.env.REFRESH_TOKEN_SECRET || 'kurukshetra-refresh-secret-dev';
    this.JWT_EXPIRY = '24h';
    this.REFRESH_EXPIRY = '7d';
  }

  /**
   * Register a new user
   */
  async register(userData) {
    const { email, password, phone, firstName, lastName, role = 'FARMER', district, taluka, village } = userData;

    try {
      // Validate input
      if (!email || !password) {
        throw new Error('Email and password are required');
      }

      // Check if user already exists by email
      const emailSnapshot = await this.db
        .collection('users')
        .where('email', '==', email)
        .limit(1)
        .get();

      if (!emailSnapshot.empty) {
        throw new Error('User with this email already exists');
      }

      // Check if phone is unique (if provided)
      if (phone) {
        const phoneSnapshot = await this.db
          .collection('users')
          .where('phone', '==', phone)
          .limit(1)
          .get();

        if (!phoneSnapshot.empty) {
          throw new Error('User with this phone number already exists');
        }
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(password, 10);

      // Generate user ID
      const userId = this.db.collection('users').doc().id;

      // Create user data
      const userData_obj = {
        uid: userId,
        email,
        password: hashedPassword,
        phone: phone || null,
        firstName: firstName || null,
        lastName: lastName || null,
        role,
        district: district || null,
        taluka: taluka || null,
        village: village || null,
        isVerified: true, // Mark as verified after successful registration
        profileImage: null,
        createdAt: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.Timestamp.now()
      };

      // Save to Firestore
      await this.db.collection('users').doc(userId).set(userData_obj);

      // Create default preferences
      await this.db.collection('userPreferences').doc(userId).set({
        userId,
        weatherAlerts: true,
        diseaseAlerts: true,
        priceAlerts: true,
        recommendationAlerts: true,
        language: 'en',
        theme: 'light',
        timezone: 'UTC',
        createdAt: admin.firestore.Timestamp.now()
      });

      // Return user without password
      const { password: _, ...userWithoutPassword } = userData_obj;
      console.log('✅ User registered in Firestore:', email);
      return userWithoutPassword;
    } catch (error) {
      console.error('❌ Registration error:', error.message);
      throw error;
    }
  }

  /**
   * Login user with email and password
   */
  async login(email, password) {
    try {
      if (!email || !password) {
        throw new Error('Email and password are required');
      }

      // Find user by email in Firestore
      const snapshot = await this.db
        .collection('users')
        .where('email', '==', email)
        .limit(1)
        .get();

      if (snapshot.empty) {
        throw new Error('Invalid email or password');
      }

      const userDoc = snapshot.docs[0];
      const user = { uid: userDoc.id, ...userDoc.data() };

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        throw new Error('Invalid email or password');
      }

      // Generate tokens
      const { accessToken, refreshToken } = this.generateTokens(user);

      // Return user and tokens
      const { password: _, ...userWithoutPassword } = user;
      console.log('✅ User logged in:', email);
      return {
        user: userWithoutPassword,
        accessToken,
        refreshToken,
        expiresIn: 86400 // 24 hours in seconds
      };
    } catch (error) {
      console.error('❌ Login error:', error.message);
      throw error;
    }
  }

  /**
   * Get user by ID
   */
  async getUserById(userId) {
    try {
      const userDoc = await this.db.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw new Error('User not found');
      }

      const user = { uid: userDoc.id, ...userDoc.data() };
      const { password: _, ...userWithoutPassword } = user;
      return userWithoutPassword;
    } catch (error) {
      console.error('❌ Get user error:', error.message);
      throw error;
    }
  }

  /**
   * Get user by email
   */
  async getUserByEmail(email) {
    try {
      const snapshot = await this.db
        .collection('users')
        .where('email', '==', email)
        .limit(1)
        .get();

      if (snapshot.empty) {
        return null;
      }

      const userDoc = snapshot.docs[0];
      const user = { uid: userDoc.id, ...userDoc.data() };
      return user;
    } catch (error) {
      console.error('❌ Get user by email error:', error.message);
      throw error;
    }
  }

  /**
   * Update user profile
   */
  async updateProfile(userId, updates) {
    try {
      const allowedUpdates = [
        'firstName',
        'lastName',
        'phone',
        'profileImage',
        'location',
        'district',
        'taluka',
        'village',
        'latitude',
        'longitude'
      ];

      const updateData = {};
      allowedUpdates.forEach(field => {
        if (field in updates) {
          updateData[field] = updates[field];
        }
      });

      updateData.updatedAt = admin.firestore.Timestamp.now();

      await this.db.collection('users').doc(userId).update(updateData);

      const updatedUser = await this.getUserById(userId);
      console.log('✅ Profile updated:', userId);
      return updatedUser;
    } catch (error) {
      console.error('❌ Profile update error:', error.message);
      throw error;
    }
  }

  /**
   * Change password
   */
  async changePassword(userId, oldPassword, newPassword) {
    try {
      const user = await this.getUserById(userId);

      // Verify old password
      const isPasswordValid = await bcrypt.compare(oldPassword, user.password);
      if (!isPasswordValid) {
        throw new Error('Current password is incorrect');
      }

      // Hash new password
      const hashedPassword = await bcrypt.hash(newPassword, 10);

      // Update password in Firestore
      await this.db.collection('users').doc(userId).update({
        password: hashedPassword,
        updatedAt: admin.firestore.Timestamp.now()
      });

      console.log('✅ Password changed:', userId);
      return { message: 'Password changed successfully' };
    } catch (error) {
      console.error('❌ Change password error:', error.message);
      throw error;
    }
  }

  /**
   * Get user preferences
   */
  async getUserPreferences(userId) {
    try {
      const prefsDoc = await this.db.collection('userPreferences').doc(userId).get();

      if (!prefsDoc.exists) {
        // Create default preferences if not found
        const defaultPrefs = {
          userId,
          weatherAlerts: true,
          diseaseAlerts: true,
          priceAlerts: true,
          recommendationAlerts: true,
          language: 'en',
          theme: 'light',
          timezone: 'UTC',
          createdAt: admin.firestore.Timestamp.now()
        };
        await this.db.collection('userPreferences').doc(userId).set(defaultPrefs);
        return defaultPrefs;
      }

      return prefsDoc.data();
    } catch (error) {
      console.error('❌ Get preferences error:', error.message);
      throw error;
    }
  }

  /**
   * Update user preferences
   */
  async updatePreferences(userId, updates) {
    try {
      const allowedUpdates = [
        'weatherAlerts',
        'diseaseAlerts',
        'priceAlerts',
        'recommendationAlerts',
        'language',
        'theme',
        'timezone'
      ];

      const updateData = {};
      allowedUpdates.forEach(field => {
        if (field in updates) {
          updateData[field] = updates[field];
        }
      });

      updateData.updatedAt = admin.firestore.Timestamp.now();

      await this.db.collection('userPreferences').doc(userId).update(updateData);

      const updatedPrefs = await this.getUserPreferences(userId);
      console.log('✅ Preferences updated:', userId);
      return updatedPrefs;
    } catch (error) {
      console.error('❌ Update preferences error:', error.message);
      throw error;
    }
  }

  /**
   * Generate JWT tokens
   */
  generateTokens(user) {
    const accessToken = jwt.sign(
      {
        id: user.uid,
        email: user.email,
        role: user.role
      },
      this.JWT_SECRET,
      { expiresIn: this.JWT_EXPIRY }
    );

    const refreshToken = jwt.sign(
      {
        id: user.uid,
        email: user.email
      },
      this.REFRESH_SECRET,
      { expiresIn: this.REFRESH_EXPIRY }
    );

    return { accessToken, refreshToken };
  }

  /**
   * Verify JWT token
   */
  verifyToken(token) {
    try {
      return jwt.verify(token, this.JWT_SECRET);
    } catch (error) {
      throw new Error('Invalid token');
    }
  }

  /**
   * Refresh access token
   */
  refreshAccessToken(refreshToken) {
    try {
      const decoded = jwt.verify(refreshToken, this.REFRESH_SECRET);
      const newAccessToken = jwt.sign(
        {
          id: decoded.id,
          email: decoded.email
        },
        this.JWT_SECRET,
        { expiresIn: this.JWT_EXPIRY }
      );
      return newAccessToken;
    } catch (error) {
      throw new Error('Invalid refresh token');
    }
  }
}

module.exports = FirestoreUserService;
