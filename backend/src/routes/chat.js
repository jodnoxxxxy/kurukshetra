const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { prisma } = require('../config/database');

// GET /api/v1/chat/history
router.get('/history', authenticate, async (req, res) => {
  try {
    const { sessionId, limit = 50 } = req.query;

    const where = { farmerId: req.user.id };
    if (sessionId) where.sessionId = sessionId;

    const messages = await prisma.chatMessage.findMany({
      where,
      orderBy: { createdAt: 'asc' },
      take: parseInt(limit),
    });

    res.status(200).json({
      status: 'success',
      data: { messages },
    });
  } catch (error) {
    console.error('Get chat history error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch chat history',
    });
  }
});

// GET /api/v1/chat/sessions
router.get('/sessions', authenticate, async (req, res) => {
  try {
    const sessions = await prisma.chatMessage.findMany({
      where: { farmerId: req.user.id },
      select: {
        sessionId: true,
        createdAt: true,
      },
      distinct: ['sessionId'],
      orderBy: { createdAt: 'desc' },
    });

    res.status(200).json({
      status: 'success',
      data: { sessions },
    });
  } catch (error) {
    console.error('Get chat sessions error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch chat sessions',
    });
  }
});

// POST /api/v1/chat/message
router.post('/message', authenticate, async (req, res) => {
  try {
    const { messageText, sessionId, messageType = 'text' } = req.body;

    // Save user message
    const userMessage = await prisma.chatMessage.create({
      data: {
        farmerId: req.user.id,
        sessionId: sessionId || `session_${Date.now()}`,
        messageText,
        isFromUser: true,
        messageType,
      },
    });

    // TODO: Integrate with AI service for response
    // For now, return a simple acknowledgment
    res.status(201).json({
      status: 'success',
      data: { 
        message: userMessage,
        aiResponse: 'AI service integration pending',
      },
    });
  } catch (error) {
    console.error('Send chat message error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to send message',
    });
  }
});

// DELETE /api/v1/chat/sessions/:sessionId
router.delete('/sessions/:sessionId', authenticate, async (req, res) => {
  try {
    const { sessionId } = req.params;

    // Verify session belongs to user
    const existingSession = await prisma.chatMessage.findFirst({
      where: { 
        sessionId, 
        farmerId: req.user.id 
      },
    });

    if (!existingSession) {
      return res.status(404).json({
        status: 'error',
        message: 'Chat session not found',
      });
    }

    await prisma.chatMessage.deleteMany({
      where: { 
        sessionId, 
        farmerId: req.user.id 
      },
    });

    res.status(200).json({
      status: 'success',
      message: 'Chat session deleted successfully',
    });
  } catch (error) {
    console.error('Delete chat session error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to delete chat session',
    });
  }
});

module.exports = router;
