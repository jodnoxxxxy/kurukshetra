# Kurukshetra Backend API Documentation

## Overview

This is the REST API documentation for the Kurukshetra Smart Farming Application backend.

## Base URL

```
Development: http://localhost:5000/api/v1
Production: https://your-domain.com/api/v1
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Endpoints

### Authentication

#### Register Farmer
```http
POST /auth/register
```

**Request Body:**
```json
{
  "name": "John Farmer",
  "email": "john@example.com",
  "phone": "+919876543210",
  "password": "password123",
  "location": "Punjab",
  "state": "Punjab",
  "district": "Ludhiana"
}
```

**Response (201):**
```json
{
  "status": "success",
  "data": {
    "farmer": {
      "id": "uuid",
      "name": "John Farmer",
      "email": "john@example.com",
      "verified": false
    },
    "token": "jwt-token"
  }
}
```

#### Login
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "status": "success",
  "data": {
    "farmer": {
      "id": "uuid",
      "name": "John Farmer",
      "email": "john@example.com",
      "verified": false
    },
    "token": "jwt-token"
  }
}
```

### Farmers (Protected)

#### Get Profile
```http
GET /farmers/profile
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "status": "success",
  "data": {
    "farmer": {
      "id": "uuid",
      "name": "John Farmer",
      "email": "john@example.com",
      "phone": "+919876543210",
      "location": "Punjab",
      "state": "Punjab",
      "district": "Ludhiana",
      "verified": true,
      "languagePreference": "en"
    }
  }
}
```

#### Update Profile
```http
PUT /farmers/profile
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "name": "Updated Name",
  "phone": "+919876543211",
  "location": "New Location"
}
```

#### Get Farms
```http
GET /farmers/farms
Authorization: Bearer <token>
```

#### Create Farm
```http
POST /farmers/farms
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "farmName": "My Farm",
  "locationName": "Village Farm",
  "latitude": 30.7,
  "longitude": 76.7,
  "areaAcres": 5.5,
  "soilType": "Loamy",
  "irrigationSource": "Canal"
}
```

### Market Prices

#### Get Current Prices
```http
GET /market/prices?crop=wheat&state=punjab&limit=20
```

**Query Parameters:**
- `crop` (optional): Filter by crop name
- `state` (optional): Filter by state
- `district` (optional): Filter by district
- `limit` (optional): Number of results (default: 50)

**Response (200):**
```json
{
  "status": "success",
  "data": {
    "prices": [
      {
        "id": "uuid",
        "cropName": "Wheat",
        "variety": "HD-2967",
        "pricePerQuintal": 2200,
        "mandiName": "Delhi Mandi",
        "district": "Central Delhi",
        "state": "Delhi",
        "priceDate": "2024-03-07",
        "changePercent": 2.5,
        "trend": "up"
      }
    ]
  }
}
```

#### Get Price History
```http
GET /market/prices/history?crop=wheat&days=30
```

#### Get Nearby Mandis
```http
GET /market/mandis?state=punjab
```

### AI Services

#### Soil Analysis
```http
POST /ai/soil-analysis
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "n": 120,
  "p": 40,
  "k": 180,
  "ph": 6.5,
  "soilType": "Loamy",
  "farmId": "uuid" // optional
}
```

**Response (200):**
```json
{
  "status": "success",
  "data": {
    "analysis": {
      "health_score": 75.5,
      "deficiencies": ["Phosphorus"],
      "recommendations": [
        {
          "type": "fertilizer",
          "nutrient": "Phosphorus",
          "suggestion": "Apply phosphorus-rich fertilizer (DAP, SSP)",
          "amount": "40-60 kg/ha depending on crop"
        }
      ]
    },
    "record": {
      "id": "uuid",
      "farmId": "uuid",
      "healthScore": 75.5
    }
  }
}
```

### Chat (Protected)

#### Get Chat History
```http
GET /chat/history?sessionId=session_123&limit=50
Authorization: Bearer <token>
```

#### Send Message
```http
POST /chat/message
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "messageText": "What is the price of wheat?",
  "sessionId": "session_123",
  "messageType": "text"
}
```

#### Get Chat Sessions
```http
GET /chat/sessions
Authorization: Bearer <token>
```

## WebSocket Events

### Connection
Connect with JWT token:
```javascript
const socket = io('ws://localhost:5000', {
  auth: {
    token: 'your-jwt-token'
  }
});
```

### Events

#### Client → Server
- `join_chat` - Join a chat room
- `send_message` - Send a message
- `typing_start` - User started typing
- `typing_stop` - User stopped typing

#### Server → Client
- `receive_message` - Message received in chat
- `ai_response` - AI response to message
- `user_typing` - User is typing indicator
- `user_stopped_typing` - User stopped typing indicator

## Error Responses

All error responses follow this format:

```json
{
  "status": "error",
  "message": "Error description"
}
```

### Common HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `401` - Unauthorized (authentication required)
- `403` - Forbidden (invalid token)
- `404` - Not Found
- `500` - Internal Server Error

## Rate Limiting

All API endpoints are rate-limited to 100 requests per 15 minutes per IP address.

## Testing

Use the provided test credentials:
- Email: `ramesh@example.com`
- Password: `password123`

Or create new accounts via the registration endpoint.
