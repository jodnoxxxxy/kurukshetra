const admin = require('firebase-admin');

class FirestoreOTPService {
  constructor() {
    this.db = admin.firestore();
    this.OTP_VALIDITY = 15 * 60 * 1000; // 15 minutes in milliseconds
    this.MAX_ATTEMPTS = 3;
  }

  /**
   * Generate a 6-digit OTP
   */
  generateOTP() {
    // For testing, always return 123456
    // In production, use: return Math.floor(100000 + Math.random() * 900000).toString();
    return '123456';
  }

  /**
   * Send OTP to phone number
   */
  async sendOTP(phone) {
    try {
      if (!phone || phone.length !== 10) {
        throw new Error('Invalid phone number');
      }

      // Check if phone already has active OTP
      const otpDoc = await this.db.collection('otps').doc(phone).get();

      if (otpDoc.exists) {
        const data = otpDoc.data();
        const createdAt = data.createdAt.toMillis();
        const now = Date.now();

        // If OTP still valid, return existing OTP (for testing)
        if (now - createdAt < this.OTP_VALIDITY) {
          return {
            success: true,
            message: 'OTP sent successfully',
            otp: data.otp, // For testing only, remove in production
            expiresIn: Math.ceil((this.OTP_VALIDITY - (now - createdAt)) / 1000)
          };
        }
      }

      // Generate new OTP
      const otp = this.generateOTP();
      const now = new Date();

      // Save OTP to Firestore
      await this.db.collection('otps').doc(phone).set({
        phone,
        otp,
        createdAt: admin.firestore.Timestamp.now(),
        expiresAt: admin.firestore.Timestamp.fromDate(new Date(now.getTime() + this.OTP_VALIDITY)),
        attempts: 0,
        verified: false
      });

      console.log(`✅ OTP sent to ${phone}: ${otp}`);

      return {
        success: true,
        message: 'OTP sent successfully',
        otp, // For testing only, remove in production
        expiresIn: Math.ceil(this.OTP_VALIDITY / 1000)
      };
    } catch (error) {
      console.error('❌ Send OTP error:', error.message);
      throw error;
    }
  }

  /**
   * Verify OTP
   */
  async verifyOTP(phone, otp) {
    try {
      if (!phone || !otp) {
        throw new Error('Phone and OTP are required');
      }

      const otpDoc = await this.db.collection('otps').doc(phone).get();

      if (!otpDoc.exists) {
        throw new Error('OTP not found or expired');
      }

      const data = otpDoc.data();

      // Check if OTP is expired
      const now = Date.now();
      const expiresAt = data.expiresAt.toMillis();

      if (now > expiresAt) {
        throw new Error('OTP has expired');
      }

      // Check attempts
      if (data.attempts >= this.MAX_ATTEMPTS) {
        throw new Error('Maximum verification attempts exceeded');
      }

      // Verify OTP
      if (data.otp !== otp.toString()) {
        // Increment attempts
        await this.db.collection('otps').doc(phone).update({
          attempts: admin.firestore.FieldValue.increment(1)
        });
        throw new Error('Invalid OTP');
      }

      // Mark as verified
      await this.db.collection('otps').doc(phone).update({
        verified: true,
        verifiedAt: admin.firestore.Timestamp.now()
      });

      console.log(`✅ OTP verified for ${phone}`);

      return {
        success: true,
        message: 'OTP verified successfully',
        phone
      };
    } catch (error) {
      console.error('❌ Verify OTP error:', error.message);
      throw error;
    }
  }

  /**
   * Check if OTP is verified
   */
  async isOTPVerified(phone) {
    try {
      const otpDoc = await this.db.collection('otps').doc(phone).get();

      if (!otpDoc.exists) {
        return false;
      }

      const data = otpDoc.data();
      const now = Date.now();
      const expiresAt = data.expiresAt.toMillis();

      // Check if OTP exists, is verified, and not expired
      return data.verified && now <= expiresAt;
    } catch (error) {
      console.error('❌ Check OTP verified error:', error.message);
      return false;
    }
  }

  /**
   * Resend OTP
   */
  async resendOTP(phone) {
    try {
      // Delete old OTP
      await this.db.collection('otps').doc(phone).delete();

      // Send new OTP
      return await this.sendOTP(phone);
    } catch (error) {
      console.error('❌ Resend OTP error:', error.message);
      throw error;
    }
  }

  /**
   * Clean up expired OTPs (run periodically)
   */
  async cleanupExpiredOTPs() {
    try {
      const now = admin.firestore.Timestamp.now();
      const snapshot = await this.db
        .collection('otps')
        .where('expiresAt', '<', now)
        .get();

      let deletedCount = 0;
      for (const doc of snapshot.docs) {
        await doc.ref.delete();
        deletedCount++;
      }

      console.log(`✅ Cleaned up ${deletedCount} expired OTPs`);
      return deletedCount;
    } catch (error) {
      console.error('❌ Cleanup expired OTPs error:', error.message);
      throw error;
    }
  }
}

module.exports = FirestoreOTPService;
