const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { prisma } = require('../config/database');
const chatService = require('../services/chat.service');

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
    const currentSessionId = sessionId || `session_${Date.now()}`;

    // 1. Save user message to database
    const userMessage = await prisma.chatMessage.create({
      data: {
        farmerId: req.user.id,
        sessionId: currentSessionId,
        messageText,
        isFromUser: true,
        messageType,
      },
    });

    // 2. Fetch recent chat history for context
    const history = await prisma.chatMessage.findMany({
      where: { sessionId: currentSessionId, farmerId: req.user.id },
      orderBy: { createdAt: 'asc' },
      take: 10,
    });

    // 3. Generate powerful AI response using the ChatService
    const aiResponseText = await chatService.generateResponse(history, messageText);

    // 4. Save AI response to database
    const assistantMessage = await prisma.chatMessage.create({
      data: {
        farmerId: req.user.id,
        sessionId: currentSessionId,
        messageText: aiResponseText,
        isFromUser: false,
        messageType: 'text',
      },
    });

    res.status(201).json({
      status: 'success',
      data: { 
        message: userMessage,
        aiResponse: assistantMessage,
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
