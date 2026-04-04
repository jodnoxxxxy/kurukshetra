// Kurukshetra Backend Server
// Entry point

const { app, server } = require('./src/app');

// Start server
const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`🚀 Kurukshetra Backend Server running on port ${PORT}`);
  console.log(`📍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⏰ Time: ${new Date().toLocaleString()}`);
  console.log(``);
  console.log(`API Endpoints:`);
  console.log(`  Health: http://localhost:${PORT}/health`);
  console.log(`  Auth:   http://localhost:${PORT}/api/v1/auth`);
  console.log(`  Farmers: http://localhost:${PORT}/api/v1/farmers`);
  console.log(`  Market: http://localhost:${PORT}/api/v1/market`);
  console.log(`  AI:     http://localhost:${PORT}/api/v1/ai`);
  console.log(`  Chat:   http://localhost:${PORT}/api/v1/chat`);
  console.log(``);
  console.log(`WebSocket: ws://localhost:${PORT}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});
