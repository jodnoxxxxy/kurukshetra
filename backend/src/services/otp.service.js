/**
 * OTP Service
 * Handles OTP generation, validation, and management
 */

const crypto = require('crypto');
const { prisma } = require('../config/database');
const logger = require('../utils/logger');

class OTPService {
  /**
   * Generate a 6-digit OTP
   * For testing: Always returns 123456
   * For production: Use crypto.randomInt(100000, 999999).toString()
   */
  generateOTP() {
    // Testing: Fixed OTP
    return '123456';
    // Production: Random OTP
    // return crypto.randomInt(100000, 999999).toString();
  }

  /**
   * Send OTP to user's phone (For production, integrate with Twilio/AWS SNS)
   * For now, stores OTP in DB and can be retrieved for testing
   */
  async sendOTP(phone, email = null) {
    try {
      if (!phone || phone.length < 10) {
        throw new Error('Invalid phone number');
      }

      // Check if user already exists with this phone
      const existingUser = await prisma.user.findFirst({
        where: { phone: phone.trim() }
      });

      if (existingUser && existingUser.verified) {
        throw new Error('User already registered with this phone number');
      }

      // Generate 6-digit OTP
      const otp = this.generateOTP();
      const otpExpiry = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes from now

      // Store OTP in database
      await prisma.OTP.upsert({
        where: { phone },
        update: {
          code: otp,
          expiresAt: otpExpiry,
          verified: false,
          attempts: 0
        },
        create: {
          phone,
          code: otp,
          expiresAt: otpExpiry,
          verified: false,
          attempts: 0
        }
      });

      // Log OTP (In production, this would call SMS provider)
      logger.info('OTP for ' + phone + ': ' + otp);

      return {
        success: true,
        message: 'OTP sent successfully',
        phone: phone,
        // IMPORTANT: Remove this line in production
        otp: otp, // Only for testing/demo
      };
    } catch (error) {
      logger.error('OTP sending failed for ' + phone + ':', error);
      throw error;
    }
  }

  /**
   * Verify OTP
   */
  async verifyOTP(phone, code) {
    try {
      if (!phone || !code) {
        throw new Error('Phone and OTP code are required');
      }

      const otpRecord = await prisma.OTP.findUnique({
        where: { phone }
      });

      if (!otpRecord) {
        throw new Error('No OTP found for this phone number');
      }

      // Check expiry
      if (new Date() > otpRecord.expiresAt) {
        throw new Error('OTP has expired');
      }

      // Check attempts (Max 5)
      if (otpRecord.attempts >= 5) {
        throw new Error('Maximum verification attempts exceeded');
      }

      // Verify code
      if (otpRecord.code !== code) {
        // Increment attempts
        await prisma.OTP.update({
          where: { phone },
          data: { attempts: { increment: 1 } }
        });
        throw new Error('Invalid OTP code');
      }

      // Mark as verified
      await prisma.OTP.update({
        where: { phone },
        data: {
          verified: true
        }
      });

      return {
        success: true,
        message: 'OTP verified successfully'
      };
    } catch (error) {
      logger.error('OTP verification failed for ' + phone + ':', error);
      throw error;
    }
  }

  /**
   * Check if phone is verified
   */
  async isVerified(phone) {
    try {
      const otpRecord = await prisma.OTP.findUnique({
        where: { phone }
      });

      if (!otpRecord) return false;

      // Must be verified AND not expired (createdAt + 30m)
      const thirtyMinutesAgo = new Date(Date.now() - 30 * 60 * 1000);
      return otpRecord.verified && otpRecord.updatedAt > thirtyMinutesAgo;
    } catch (error) {
      return false;
    }
  }
}

module.exports = new OTPService();
