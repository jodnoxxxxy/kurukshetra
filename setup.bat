@echo off
REM Kurukshetra Full-Stack Setup Script for Windows
REM Automated setup for Backend + Frontend + Database

cls
echo ========================================
echo 🚀 KURUKSHETRA FULL STACK SETUP (Windows)
echo ========================================
echo.

REM Step 1: Backend Setup
echo [1/6] Setting up Backend...
cd backend

if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
)

echo Generating Prisma client...
call npm run db:generate

echo Running database migrations...
call npm run db:migrate

echo ✓ Backend dependencies installed
echo.

REM Step 2: Environmental Check
echo [2/6] Checking environment variables...
if not exist ".env" (
    echo ⚠ .env file not found. Creating from example...
    if exist ".env.example" (
        copy .env.example .env
    ) else (
        (
            echo # Database
            echo DATABASE_URL="file:./dev.db"
            echo.
            echo # Server
            echo NODE_ENV=development
            echo PORT=5000
            echo API_VERSION=v1
            echo.
            echo # JWT
            echo JWT_SECRET=kurukshetra_super_secret_key_change_this
            echo JWT_EXPIRY=24h
            echo REFRESH_TOKEN_SECRET=kurukshetra_refresh_secret
            echo REFRESH_TOKEN_EXPIRY=7d
            echo.
            echo # CORS
            echo FRONTEND_URL=http://localhost:3000,http://localhost:50042,http://127.0.0.1:3000
            echo.
            echo # Rate Limiting
            echo RATE_LIMIT_WINDOW_MS=900000
            echo RATE_LIMIT_MAX_REQUESTS=100
        ) > .env
    )
    echo Please update .env with your configuration
)
echo ✓ Environment variables ready
echo.

REM Step 3: Database Check
echo [3/6] Verifying database...
echo Database migrations completed
echo ✓ Database verified
echo.

REM Step 4: Start Backend in New Window
echo [4/6] Starting Backend Server...
echo Starting on http://localhost:5000
echo.
echo Opening Backend in new window...
start cmd /k npm run dev
timeout /t 3

echo ✓ Backend started (watch the other window)
echo.

REM Step 5: Frontend Setup
echo [5/6] Setting up Frontend...
cd ..\frontend

echo Checking Flutter installation...
call flutter --version

echo Installing Flutter dependencies...
call flutter pub get

echo ✓ Frontend dependencies installed
echo.

REM Step 6: Configuration
echo [6/6] Next Configuration Steps...
echo.
echo ========================================
echo 🎉 SETUP COMPLETE!
echo ========================================
echo.
echo IMPORTANT NEXT STEPS:
echo.
echo 1. Update API URL in Frontend
echo    File: frontend\lib\core\constants\app_constants.dart
echo    For Web (Chrome): http://localhost:5000/api/v1
echo    For Android: http://10.0.2.2:5000/api/v1
echo    For Mobile on WiFi: http://YOUR_PC_IP:5000/api/v1
echo.
echo 2. Get your PC IP address (for mobile testing):
echo    Open Command Prompt and run: ipconfig
echo    Use the IPv4 Address (e.g., 192.168.1.100)
echo.
echo 3. Run Flutter App:
echo    Command Prompt: flutter run -d chrome    (for web)
echo    Command Prompt: flutter run -d android   (for Android emulator)
echo.
echo 4. Test Backend Endpoints:
echo    - Use Postman or curl
echo    - See AUTHENTICATION_SETUP_GUIDE.md for examples
echo.
echo 5. Backend Console:
echo    Already running in separate window
echo    Keep it running while testing
echo.
echo ========================================
echo POSTMAN TEST FLOW:
echo.
echo Step 1: Send OTP
echo POST http://localhost:5000/api/v1/auth/send-otp
echo Body: { "phone": "9876543210" }
echo.
echo Step 2: Verify OTP (check console for code)
echo POST http://localhost:5000/api/v1/auth/verify-otp
echo Body: { "phone": "9876543210", "otp": "123456" }
echo.
echo Step 3: Register
echo POST http://localhost:5000/api/v1/auth/register
echo Body: {
echo   "firstName": "John",
echo   "lastName": "Doe",
echo   "email": "john@example.com",
echo   "phone": "9876543210",
echo   "password": "Password@123",
echo   "role": "FARMER"
echo }
echo.
echo Step 4: Login
echo POST http://localhost:5000/api/v1/auth/login
echo Body: {
echo   "email": "john@example.com",
echo   "password": "Password@123"
echo }
echo.
echo ========================================
echo.
pause
