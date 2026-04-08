const logger = require('../utils/logger');

/**
 * Centralized error handling middleware
 * Catches all errors and returns consistent response format
 */
class ErrorHandler extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
  }
}

const errorHandlingMiddleware = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;

  // Log error details
  logger.error({
    message: err.message,
    statusCode: err.statusCode,
    stack: err.stack,
    path: req.path,
    method: req.method,
    ip: req.ip,
  });

  // Prisma validation errors
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      statusCode: 400,
      message: 'Validation error',
      details: err.message,
    });
  }

  // Prisma unique constraint violation
  if (err.code === 'P2002') {
    const field = err.meta?.target?.[0] || 'field';
    return res.status(409).json({
      success: false,
      statusCode: 409,
      message: `${field} already exists`,
    });
  }

  // Prisma record not found
  if (err.code === 'P2025') {
    return res.status(404).json({
      success: false,
      statusCode: 404,
      message: 'Record not found',
    });
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      success: false,
      statusCode: 401,
      message: 'Invalid token',
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      statusCode: 401,
      message: 'Token expired',
    });
  }

  // Custom error handler
  if (err instanceof ErrorHandler) {
    return res.status(err.statusCode).json({
      success: false,
      statusCode: err.statusCode,
      message: err.message,
    });
  }

  // Default error response
  res.status(err.statusCode).json({
    success: false,
    statusCode: err.statusCode,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

/**
 * Async error wrapper for route handlers
 * Wraps async route handlers and catches any errors
 */
const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = {
  ErrorHandler,
  errorHandlingMiddleware,
  asyncHandler,
};
