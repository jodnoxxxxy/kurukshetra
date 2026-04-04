// Kurukshetra Backend Server
// Entry point

const { startServer } = require('./src/app');

// Start server with database connection
startServer().catch(error => {
  console.error('Failed to start server:', error);
  process.exit(1);
});
