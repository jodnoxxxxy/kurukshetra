# Kurukshetra Backend

Node.js + PostgreSQL backend for the Kurukshetra Smart Farming Application.

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 15+
- Redis (optional, for caching)

### Installation

```bash
# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your database credentials

# Start development server
npm run dev
```

### Test Server

Visit `http://localhost:5000/health` in your browser or use:

```bash
curl http://localhost:5000/health
```

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # Database models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── sockets/         # WebSocket handlers
│   └── utils/           # Utility functions
├── logs/                # Application logs
├── uploads/             # File uploads
├── .env                 # Environment variables
├── server.js            # Entry point
└── package.json
```

## 🔌 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new farmer
- `POST /api/v1/auth/login` - Login

### Farmers
- `GET /api/v1/farmers/profile` - Get farmer profile
- `PUT /api/v1/farmers/profile` - Update profile

### Market Prices
- `GET /api/v1/market/prices` - Get current market prices

### AI Services
- `POST /api/v1/ai/soil-analysis` - Analyze soil sample
- `POST /api/v1/ai/pest-detection` - Detect pests from image

### Chat
- `GET /api/v1/chat/history` - Get chat history
- WebSocket: `ws://localhost:5000`

## 🗄️ Database Setup

```sql
-- Create database
CREATE DATABASE kurukshetra;

-- Run migrations (after setting up Prisma)
npx prisma migrate dev
```

## 🧪 Testing

```bash
# Run tests
npm test

# Run with coverage
npm test -- --coverage
```

## 📝 Development

```bash
# Start development server with auto-reload
npm run dev

# Lint code
npm run lint

# Format code
npm run format
```

## 🔒 Security

- JWT authentication for protected routes
- Password hashing with bcrypt (12 rounds)
- Rate limiting on all endpoints
- Input validation with Joi
- CORS configuration

## 🌐 WebSocket Events

### Client → Server
- `join_room` - Join a room
- `send_message` - Send chat message
- `typing_start` - User started typing
- `typing_stop` - User stopped typing

### Server → Client
- `receive_message` - Message received
- `user_typing` - User is typing
- `user_stopped_typing` - User stopped typing

## 🛠️ Tech Stack

- **Runtime:** Node.js 18+
- **Framework:** Express.js
- **Database:** PostgreSQL 15+
- **ORM:** Prisma
- **Real-time:** Socket.IO
- **Authentication:** JWT + bcrypt
- **Validation:** Joi
- **Logging:** Winston + Morgan
- **Security:** Helmet, CORS, Rate Limiting

## 📞 Support

For issues or questions, please refer to the main project documentation.

---

**Built for Kurukshetra Smart Farming Initiative** 🚜🌾
