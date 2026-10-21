# Flutter Authentication Integration Guide

## Quick Start

The backend authentication system is ready. Here's how to integrate it into the Flutter app:

### 1. Verify Configuration

Check that the backend URL is correct in your Flutter app:

```dart
// File: lib/core/services/api_client.dart
// or: lib/services/api_service.dart

const String baseUrl = 'http://localhost:5000/api/v1';
```

### 2. Using the OTP Service

```dart
// Import the OTP service
import 'package:kurukshetra/features/auth/services/otp_service.dart';
import 'package:kurukshetra/features/auth/providers/otp_provider.dart';

// Send OTP
try {
  final result = await otpService.sendOTP(phone: '7777777777');
  print('OTP sent: ${result['message']}');
  // OTP is stored in DB and available for testing
} catch (e) {
  print('Error: $e');
}

// Verify OTP
try {
  final result = await otpService.verifyOTP(
    phone: '7777777777',
    otp: '146966'
  );
  print('OTP verified: ${result['verified']}');
} catch (e) {
  print('Error: $e');
}
```

### 3. Registration Example

```dart
// Use the auth controller
try {
  final response = await dio.post(
    'http://localhost:5000/api/v1/auth/register',
    data: {
      'firstName': 'Rajesh',
      'lastName': 'Kumar',
      'email': 'rajesh@example.com',
      'phone': '7777777777',
      'password': 'Test@1234',
      'role': 'FARMER'
    }
  );
  
  final user = response.data['data'];
  print('Registered: ${user['email']}');
} catch (e) {
  print('Registration failed: $e');
}
```

### 4. Login Example

```dart
// Login with email and password
try {
  final response = await dio.post(
    'http://localhost:5000/api/v1/auth/login',
    data: {
      'email': 'rajesh@example.com',
      'password': 'Test@1234'
    }
  );
  
  final user = response.data['data']['user'];
  final accessToken = response.data['data']['accessToken'];
  final refreshToken = response.data['data']['refreshToken'];
  
  // Save tokens
  await sharedPreferences.setString('access_token', accessToken);
  await sharedPreferences.setString('refresh_token', refreshToken);
  
  print('Logged in as: ${user['firstName']} ${user['lastName']}');
} catch (e) {
  print('Login failed: $e');
}
```

### 5. Using Tokens for Protected Requests

```dart
// Add token to all API requests
final token = sharedPreferences.getString('access_token');

final response = await dio.get(
  'http://localhost:5000/api/v1/farms',
  options: Options(
    headers: {
      'Authorization': 'Bearer $token'
    }
  )
);
```

### 6. Testing Manually

Use the curl commands or PowerShell to test:

```powershell
# 1. Send OTP
$body = @{phone="7777777777"} | ConvertTo-Json
$response = Invoke-WebRequest `
  -Uri http://localhost:5000/api/v1/auth/send-otp `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body `
  -UseBasicParsing
Write-Host $response.Content

# 2. Verify OTP (use code from response)
$body = @{phone="7777777777"; otp="146966"} | ConvertTo-Json
$response = Invoke-WebRequest `
  -Uri http://localhost:5000/api/v1/auth/verify-otp `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body `
  -UseBasicParsing
Write-Host $response.Content

# 3. Register
$body = @{
  firstName="Rajesh"
  lastName="Kumar"
  email="rajesh@example.com"
  phone="7777777777"
  password="Test@1234"
  role="FARMER"
} | ConvertTo-Json
$response = Invoke-WebRequest `
  -Uri http://localhost:5000/api/v1/auth/register `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body `
  -UseBasicParsing
Write-Host $response.Content

# 4. Login
$body = @{
  email="rajesh@example.com"
  password="Test@1234"
} | ConvertTo-Json
$response = Invoke-WebRequest `
  -Uri http://localhost:5000/api/v1/auth/login `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body `
  -UseBasicParsing
Write-Host $response.Content
```

### 7. Backend Status

Check backend health:
```
GET http://localhost:5000/health

Response:
{
  "status": "ok",
  "message": "Kurukshetra Backend API is running",
  "environment": "development"
}
```

## API Response Format

### Success Response (200 OK)
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    // Response-specific data
  }
}
```

### Error Response (400/500)
```json
{
  "success": false,
  "message": "Error message describing what went wrong"
}
```

## Common Error Messages

- `"Invalid phone format"` - Phone must be 10 digits, starting with 6-9
- `"OTP has expired"` - OTP valid for 5 minutes only
- `"Maximum verification attempts exceeded"` - Max 3 attempts per OTP
- `"Invalid email or password"` - Wrong credentials
- `"User already registered"` - Email already exists

## Testing Credentials

After running the above commands, you can login with:
- **Email**: rajesh@example.com
- **Password**: Test@1234
- **Phone**: 7777777777

## Next Steps

1. Test the flow in your Flutter app
2. Verify tokens are persisted correctly
3. Test protected routes with Authorization header
4. Test token refresh flow
5. Handle token expiry and refresh

## Support

For issues:
1. Check `http://localhost:5000/health` is responding
2. Verify backend is running: `npm run dev` in `/backend/`
3. Check network debug logs in Flutter
4. Verify CORS configuration if testing from web

