const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const config = require('../config');
const logger = require('../utils/logger');

let io;

const initializeSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: config.FRONTEND_URL,
      methods: ['GET', 'POST'],
      credentials: true,
    },
  });

  // Socket authentication middleware
  io.use((socket, next) => {
    try {
      const token = socket.handshake.auth.token;
      
      if (!token) {
        return next(new Error('Authentication error'));
      }

      const decoded = jwt.verify(token, config.JWT_SECRET);
      socket.user = decoded;
      next();
    } catch (error) {
      logger.error('Socket authentication error:', error);
      next(new Error('Authentication error'));
    }
  });

  io.on('connection', (socket) => {
    logger.info(`User connected: ${socket.user.id}`);

    // Join user's personal room
    socket.join(`user_${socket.user.id}`);

    // Handle joining chat rooms
    socket.on('join_chat', (sessionId) => {
      socket.join(`chat_${sessionId}`);
      logger.info(`User ${socket.user.id} joined chat room: ${sessionId}`);
    });

    // Handle sending messages
    socket.on('send_message', async (data) => {
      try {
        const { sessionId, messageText, messageType = 'text' } = data;
        
        // Broadcast to all users in the chat room
        io.to(`chat_${sessionId}`).emit('receive_message', {
          id: Date.now(),
          sessionId,
          messageText,
          messageType,
          isFromUser: true,
          senderId: socket.user.id,
          timestamp: new Date().toISOString(),
        });

        // TODO: Process with AI service and send response
        // For now, send a simple acknowledgment
        setTimeout(() => {
          io.to(`chat_${sessionId}`).emit('ai_response', {
            id: Date.now() + 1,
            sessionId,
            messageText: 'AI response will be implemented here',
            messageType: 'text',
            isFromUser: false,
            timestamp: new Date().toISOString(),
          });
        }, 1000);

      } catch (error) {
        logger.error('Send message error:', error);
        socket.emit('error', { message: 'Failed to send message' });
      }
    });

    // Handle typing indicators
    socket.on('typing_start', (sessionId) => {
      socket.to(`chat_${sessionId}`).emit('user_typing', {
        userId: socket.user.id,
        sessionId,
      });
    });

    socket.on('typing_stop', (sessionId) => {
      socket.to(`chat_${sessionId}`).emit('user_stopped_typing', {
        userId: socket.user.id,
        sessionId,
      });
    });

    // Handle disconnection
    socket.on('disconnect', () => {
      logger.info(`User disconnected: ${socket.user.id}`);
    });

    // Handle errors
    socket.on('error', (error) => {
      logger.error('Socket error:', error);
    });
  });

  return io;
};

// Helper function to send notifications to specific users
const sendToUser = (userId, event, data) => {
  if (io) {
    io.to(`user_${userId}`).emit(event, data);
  }
};

// Helper function to broadcast to chat room
const broadcastToChat = (sessionId, event, data) => {
  if (io) {
    io.to(`chat_${sessionId}`).emit(event, data);
  }
};

// Get Socket.IO instance
const getIO = () => {
  if (!io) {
    throw new Error('Socket.IO not initialized. Call initializeSocket() first.');
  }
  return io;
};

module.exports = {
  initializeSocket,
  getIO,
  sendToUser,
  broadcastToChat,
};
