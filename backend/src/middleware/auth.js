const jwt = require('jsonwebtoken');
const config = require('../config');

// Verify JWT token
const verifyToken = (token) => {
  try {
    const secret = process.env.JWT_SECRET || config.JWT_SECRET;
    if (!secret) throw new Error('JWT_SECRET is not configured');
    return jwt.verify(token, secret);
  } catch (error) {
    return null;
  }
};

// Authentication middleware - Verify user is logged in
const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'Access token required',
      });
    }

    const token = authHeader.split(' ')[1];
    const jwtSecret = process.env.JWT_SECRET || config.JWT_SECRET;
    if (!jwtSecret) {
      return res.status(500).json({ success: false, message: 'Server authentication is not configured' });
    }

    // Check if it is a mock token generated during bypass mode (never allow in production)
    if (
      process.env.NODE_ENV !== 'production' &&
      (token.startsWith('mock_token_') || token.startsWith('demo_'))
    ) {
      req.user = { id: token.replace('mock_token_', '').replace('demo_', ''), role: 'FARMER' };
      return next();
    }
    
    jwt.verify(token, jwtSecret, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: 'Invalid or expired token',
        });
      }
      
      req.user = decoded;
      next();
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Authentication error',
    });
  }
};

// Authorization middleware - Check if user has required role(s)
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized'
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Forbidden - Insufficient permissions'
      });
    }

    next();
  };
};

module.exports = { 
  authenticate, 
  authorize,
  verifyToken 
};
