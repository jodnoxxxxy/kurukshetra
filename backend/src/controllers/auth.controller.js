const userService = require('../services/user.service');

class AuthController {
  // POST /api/auth/register
  async register(req, res) {
    try {
      const { email, password, phone, firstName, lastName, role } = req.body;

      // Validation
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email and password are required'
        });
      }

      const user = await userService.register({
        email,
        password,
        phone,
        firstName,
        lastName,
        role
      });
      console.log('✅ User registered successfully:', user.email);

      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: user
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/auth/login
  async login(req, res) {
    try {
      const { email, password } = req.body;

      // Validation
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email and password are required'
        });
      }

      const { user, token } = await userService.login(email, password);

      res.status(200).json({
        success: true,
        message: 'Login successful',
        data: {
          user,
          token
        }
      });
    } catch (error) {
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/auth/profile
  async getProfile(req, res) {
    try {
      const user = await userService.getUserById(req.user.id);

      res.status(200).json({
        success: true,
        data: user
      });
    } catch (error) {
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/auth/profile
  async updateProfile(req, res) {
    try {
      const user = await userService.updateProfile(req.user.id, req.body);

      res.status(200).json({
        success: true,
        message: 'Profile updated successfully',
        data: user
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/auth/change-password
  async changePassword(req, res) {
    try {
      const { oldPassword, newPassword } = req.body;

      if (!oldPassword || !newPassword) {
        return res.status(400).json({
          success: false,
          message: 'Old password and new password are required'
        });
      }

      await userService.changePassword(req.user.id, oldPassword, newPassword);

      res.status(200).json({
        success: true,
        message: 'Password changed successfully'
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // GET /api/auth/preferences
  async getPreferences(req, res) {
    try {
      const preferences = await userService.getUserPreferences(req.user.id);

      res.status(200).json({
        success: true,
        data: preferences
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // PUT /api/auth/preferences
  async updatePreferences(req, res) {
    try {
      const preferences = await userService.updatePreferences(
        req.user.id,
        req.body
      );

      res.status(200).json({
        success: true,
        message: 'Preferences updated successfully',
        data: preferences
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/auth/logout
  async logout(req, res) {
    try {
      const result = await userService.logout(req.user.id);

      res.status(200).json({
        success: true,
        message: result.message
      });
    } catch (error) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  // POST /api/auth/refresh-token
  async refreshToken(req, res) {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken) {
        return res.status(400).json({
          success: false,
          message: 'Refresh token is required'
        });
      }

      // Verify refresh token
      const decoded = await new Promise((resolve, reject) => {
        require('jsonwebtoken').verify(
          refreshToken,
          process.env.REFRESH_TOKEN_SECRET || 'kurukshetra-refresh-secret',
          (err, decoded) => {
            if (err) reject(err);
            else resolve(decoded);
          }
        );
      });

      const tokens = await userService.refreshAccessToken(decoded.id);

      res.status(200).json({
        success: true,
        message: 'Token refreshed successfully',
        data: tokens
      });
    } catch (error) {
      res.status(401).json({
        success: false,
        message: 'Invalid or expired refresh token'
      });
    }
  }
}

module.exports = new AuthController();
