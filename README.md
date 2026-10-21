# Kurukshetra — Smart Farming Platform

An end-to-end smart-farming platform for Indian farmers: AI crop recommendation, crop advisory timelines, soil/pest/fertilizer tools, market prices, government schemes, expenses/yield/analytics, plus a farmer↔consumer marketplace, chat, and learning modules.

## Architecture
```
Flutter (frontend/)
      ↓  REST (baseUrl: http://localhost:5000/api/v1)
Node.js + Express (backend/)
      ↓  Firebase Admin SDK
Firebase (Auth, Firestore, Storage, FCM)
      ↓  HTTP calls to env-configured Python services
Python ML models (ai_ml/)
```
Core flow: User → Profile → Farm → Crop (manual or AI recommendation) → Crop Advisory (stages/timeline/tasks) → Location+Weather+Soil → Advisory Engine (insights/alerts/risks) → Expense/Yield/Price → Revenue/Profit → Analytics.

## Repository structure
- `frontend/` — Flutter app (canonical UI project)
- `backend/` — Node.js/Express API + Prisma + Socket.IO
- `ai_ml/` — Python ML models/scripts
- `database/` — Prisma schema, migrations, seeds, Firestore seed
- `docs/` — API documentation

## Prerequisites
- Flutter SDK 3.9+, Dart 3.9+
- Node.js 20+, npm
- Firebase project (Auth, Firestore, Storage, Cloud Messaging)
- Python 3.10+ (for `ai_ml/`)

## Setup
### Backend
```bash
cd backend
cp .env.example .env    # fill in real values
npm install
npm run db:generate
npm run dev
```
Server starts on `http://localhost:5000`. Health: `GET /health`.

### Frontend
```bash
cd frontend
flutter pub get
flutter run                # Android emulator: use API_URL=http://10.0.2.2:5000/api/v1
```

### Firebase
1. Create a Firebase project; enable Email/Phone auth, Firestore, Storage, FCM.
2. Download service-account JSON → put as `backend/firebase-credentials.json` (git-ignored).
3. For Android/iOS/Web, place `google-services.json` / `firebase_options.dart` as usual.

## Environment variables (backend)
See `backend/.env.example` — includes `NODE_ENV, PORT, API_VERSION, DATABASE_URL, JWT_SECRET, JWT_REFRESH_SECRET, FIREBASE_PROJECT_ID/PRIVATE_KEY/CLIENT_EMAIL, CLOUDINARY_*, FRONTEND_URL, RATE_LIMIT_*, SOIL_ANALYSIS_URL, PEST_DETECTION_URL, CROP_RECOMMENDATION_URL, YIELD_PREDICTION_URL, MAX_FILE_SIZE, UPLOAD_PATH`.

## Authentication flow
Phone/OTP via Firebase Auth (or backend OTP service) → session token → Home. Mock tokens are rejected in production (`NODE_ENV=production`).

## Crop system
One Crop Advisory owner: timeline/stages/tasks. AI (or manual selection) only supplies the crop name/id → the same advisory system loads that crop's own stages/tasks. Never hardcode Rice/Pune.

## API overview
Base `http://localhost:5000/api/v1`. Key groups: `auth`, `farmers`, `farms`, `market`, `ai`, `chat`, `crops`, `climate`, `monitoring`, `diseases`, `orders`, `notifications`, `inspections`. Full reference: `backend/API_DOCUMENTATION.md`.

## Testing
```bash
cd backend && npm test                 # Jest (1 auth test currently)
cd frontend && flutter test            # Widget/unit tests
cd frontend && flutter analyze         # 0 errors expected
```

## Build & deploy
```bash
cd frontend && flutter build apk --release
cd backend && docker build -t kurukshetra-backend .
```

## Troubleshooting
- `flutter analyze` errors → run `flutter pub get`, then `dart fix --apply`.
- 401 on API → ensure `JWT_SECRET` matches the token issuer.
- CORS error → add your origin to `FRONTEND_URL` in `.env`.
- ML endpoints failing → set `SOIL_ANALYSIS_URL`/`PEST_DETECTION_URL`/`CROP_RECOMMENDATION_URL`/`YIELD_PREDICTION_URL` to running services.
