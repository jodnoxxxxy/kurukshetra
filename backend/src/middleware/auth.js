const jwt = require('jsonwebtoken');
const config = require('../config');

const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        status: 'error',
        message: 'Access token required',
      });
    }

    const token = authHeader.split(' ')[1];
    
    jwt.verify(token, config.JWT_SECRET, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          status: 'error',
          message: 'Invalid or expired token',
        });
      }
      
      req.user = decoded;
      next();
    });
  } catch (error) {
    return res.status(500).json({
      status: 'error',
      message: 'Authentication error',
    });
  }
};

module.exports = { authenticate };
