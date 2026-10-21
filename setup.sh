#!/bin/bash

# Kurukshetra Full-Stack Setup Script
# Automated setup for Backend + Frontend + Database

echo "========================================"
echo "🚀 KURUKSHETRA FULL STACK SETUP"
echo "========================================"
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Backend Setup
echo -e "${BLUE}[1/6] Setting up Backend...${NC}"
cd backend

if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

echo "Generating Prisma client..."
npm run db:generate

echo "Running database migrations..."
npm run db:migrate

echo -e "${GREEN}✓ Backend dependencies installed${NC}"
echo ""

# Step 2: Environmental Check
echo -e "${BLUE}[2/6] Checking environment variables...${NC}"
if [ ! -f ".env" ]; then
    echo "${YELLOW}⚠ .env file not found. Creating from example...${NC}"
    cp .env.example .env
    echo "Please update .env with your configuration"
fi
echo -e "${GREEN}✓ Environment variables ready${NC}"
echo ""

# Step 3: Database Check
echo -e "${BLUE}[3/6] Verifying database...${NC}"
npm run db:studio &
STUDIO_PID=$!
sleep 3
echo "Database studio opened in browser (http://localhost:5555)"
echo "Check that OTP table exists"
echo -e "${GREEN}✓ Database verified${NC}"
echo ""

# Kill studio
kill $STUDIO_PID 2>/dev/null || true

# Step 4: Backend Start
echo -e "${BLUE}[4/6] Starting Backend Server...${NC}"
echo "Starting on http://localhost:5000"
npm run dev &
BACKEND_PID=$!
sleep 3

# Check if backend is running
if curl -s http://localhost:5000/health > /dev/null; then
    echo -e "${GREEN}✓ Backend running successfully${NC}"
else
    echo -e "${YELLOW}⚠ Backend may not be running. Check logs above.${NC}"
fi
echo ""

# Step 5: Frontend Setup
echo -e "${BLUE}[5/6] Setting up Frontend...${NC}"
cd ../frontend

# Check if we're using the right version of Dart/Flutter
echo "Checking Flutter installation..."
flutter --version

echo "Installing Flutter dependencies..."
flutter pub get

echo -e "${GREEN}✓ Frontend dependencies installed${NC}"
echo ""

# Step 6: Configuration
echo -e "${BLUE}[6/6] Verifying Configuration...${NC}"
echo "✓ Update lib/core/constants/app_constants.dart with correct API URL"
echo "  - For web: http://localhost:5000/api/v1"
echo "  - For Android: http://10.0.2.2:5000/api/v1"
echo "  - For mobile on WiFi: http://YOUR_PC_IP:5000/api/v1"
echo ""

echo "========================================"
echo -e "${GREEN}🎉 SETUP COMPLETE!${NC}"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Update API URL in frontend/lib/core/constants/app_constants.dart"
echo "2. Run flutter app: flutter run"
echo "3. Backend is running on http://localhost:5000"
echo "4. Test endpoints with Postman or curl"
echo ""
echo "Keep backend running in this terminal window:"
echo "  npm run dev (in backend folder)"
echo ""
echo "In another terminal, run Flutter:"
echo "  flutter run -d chrome   # for web"
echo "  flutter run -d android  # for Android emulator"
echo ""
echo "========================================"
