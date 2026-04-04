# 🏛️ Kurukshetra - Architecture Diagram

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        KURUKSHETRA APP                          │
│                     (Flutter Mobile App)                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
│   Presentation   │ │    Business      │ │     Data         │
│      Layer       │ │     Logic        │ │     Layer        │
│                  │ │                  │ │                  │
│  • Screens       │ │  • Providers     │ │  • Repositories  │
│  • Widgets       │ │  • State Mgmt    │ │  • API Service   │
│  • Navigation    │ │  • Validation    │ │  • Local Storage │
└──────────────────┘ └──────────────────┘ └──────────────────┘
```

---

## Layer Architecture

### 1. Presentation Layer

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Home      │  │  Dashboard  │  │    Chat     │         │
│  │   Screen    │  │   Screen    │  │   Screen    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │    Learn    │  │   Profile   │  │  AI Services│         │
│  │   Screen    │  │   Screen    │  │   Screens   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Reusable Widgets                        │   │
│  │  • FeatureCard  • WeatherCard  • MessageBubble      │   │
│  │  • ChartWidget  • VideoCard    • LoadingIndicator  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Responsibilities:**
- UI rendering
- User interaction handling
- State consumption via Riverpod
- Navigation triggers

**Key Files:**
```
lib/features/
├── home/screens/home_screen.dart
├── dashboard/screens/dashboard_screen.dart
├── chat/screens/chat_screen.dart
├── learn/screens/learn_screen.dart
├── profile/screens/profile_screen.dart
└── ai_services/screens/
    ├── soil_analysis_screen.dart
    ├── pest_detection_screen.dart
    └── crop_recommendation_screen.dart
```

---

### 2. Business Logic Layer (Riverpod)

```
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                       │
│                      (Riverpod Providers)                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                 State Providers                       │  │
│  │                                                       │  │
│  │  navigationProvider      → Current tab index          │  │
│  │  themeProvider           → Light/Dark mode            │  │
│  │  languageProvider        → Selected language          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                Future Providers                       │  │
│  │                                                       │  │
│  │  weatherProvider         → Fetches weather data       │  │
│  │  marketPricesProvider    → Fetches market prices      │  │
│  │  farmerProfileProvider   → Fetches user profile       │  │
│  │  videoContentProvider    → Fetches learning videos    │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              StateNotifier Providers                  │  │
│  │                                                       │  │
│  │  chatNotifier            → Chat messages & state      │  │
│  │  cropNotifier            → Crop data management       │  │
│  │  soilAnalysisNotifier    → Soil analysis workflow     │  │
│  │  pestDetectionNotifier   → Pest detection workflow    │  │
│  │  authNotifier            → Authentication state       │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │               Stream Providers                        │  │
│  │                                                       │  │
│  │  chatMessageStream       → Real-time messages         │  │
│  │  weatherUpdateStream     → Live weather updates       │  │
│  │  priceUpdateStream       → Live price changes         │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Example Provider Flow:**

```
User Action on Screen
        ↓
Calls Provider Method
        ↓
Provider Calls Repository
        ↓
Repository Fetches Data
        ↓
Provider Updates State
        ↓
Screen Rebuilds UI
```

**Key Files:**
```
lib/providers/
├── navigation_provider.dart
├── weather_provider.dart
├── market_provider.dart
├── chat_provider.dart
├── crop_provider.dart
├── soil_analysis_provider.dart
├── pest_detection_provider.dart
└── auth_provider.dart
```

---

### 3. Data Layer (Repositories)

```
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                              │
│                    (Repositories)                            │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Repository Interfaces                    │  │
│  │                                                       │  │
│  │  WeatherRepository                                    │  │
│  │    • getCurrentWeather(location)                      │  │
│  │    • watchWeather(location)                           │  │
│  │                                                       │  │
│  │  MarketRepository                                     │  │
│  │    • getCurrentPrices()                               │  │
│  │    • getNearbyMandis(location)                        │  │
│  │    • getPriceHistory(cropId)                          │  │
│  │                                                       │  │
│  │  ChatRepository                                       │  │
│  │    • sendMessage(text)                                │  │
│  │    • getMessageStream()                               │  │
│  │    • getChatHistory(userId)                                               │  │
│  │                                                       │  │
│  │  CropRepository                                       │  │
│  │    • getPlantedCrops(farmerId)                        │  │
│  │    • addCrop(crop)                                    │  │
│  │    • updateCropHealth(cropId)                         │  │
│  │                                                       │  │
│  │  SoilAnalysisRepository                               │  │
│  │    • analyzeSoil(sample)                              │  │
│  │    • getRecommendations(soilId)                       │  │
│  │                                                       │  │
│  │  AuthRepository                                       │  │
│  │    • login(email, password)                           │  │
│  │    • register(userData)                               │  │
│  │    • logout()                                         │  │
│  │    • getCurrentUser()                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Repository Implementation Pattern:**

```dart
abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(String location);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final ApiClient apiClient;
  final LocalStorageService localStorage;
  
  @override
  Future<Weather> getCurrentWeather(String location) async {
    // Try cache first
    final cached = await localStorage.getWeather(location);
    if (cached != null && !cached.isExpired) {
      return cached;
    }
    
    // Fetch from API
    final weather = await apiClient.getWeather(location);
    
    // Update cache
    await localStorage.saveWeather(location, weather);
    
    return weather;
  }
}
```

**Key Files:**
```
lib/repositories/
├── weather_repository.dart
├── market_repository.dart
├── chat_repository.dart
├── crop_repository.dart
├── soil_analysis_repository.dart
├── auth_repository.dart
└── base_repository.dart
```

---

## Data Flow Architecture

### Read-Only Data Flow (e.g., Weather)

```
┌─────────────┐
│   Screen    │  ConsumerWidget
└──────┬──────┘
       │ ref.watch(weatherProvider)
       ▼
┌─────────────┐
│  Provider   │  StateNotifier/Notifier
└──────┬──────┘
       │ fetch()
       ▼
┌─────────────┐
│ Repository  │  Business Logic
└──────┬──────┘
       │ GET /weather
       ▼
┌─────────────┐
│  API Client │  HTTP/WebSocket
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Backend    │  Node.js Server
│   API       │  Express + MongoDB
└─────────────┘
```

### Write Data Flow (e.g., Send Chat Message)

```
┌─────────────┐
│   Screen    │  User types message
└──────┬──────┘
       │ notifier.sendMessage(text)
       ▼
┌─────────────┐
│  Provider   │  ChatNotifier
└──────┬──────┘
       │ Add to local state immediately
       │ Optimistic UI update
       │
       ├──────────────┐
       │              │
       ▼              ▼
┌─────────────┐ ┌─────────────┐
│  UI Update  │ │ Repository  │
│ (Instant)   │ │ Send to API │
└─────────────┘ └──────┬──────┘
                       │ POST /chat/send
                       ▼
                  ┌─────────────┐
                  │  Backend    │
                  │  + AI Svc   │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │   AI Model  │
                  │  Processing │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │   Response  │
                  │  (Stream)   │
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │  Provider   │
                  │ Update State│
                  └──────┬──────┘
                         │
                         ▼
                  ┌─────────────┐
                  │  UI Update  │
                  │ (AI Reply)  │
                  └─────────────┘
```

---

## Navigation Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    NAVIGATION FLOW                           │
└─────────────────────────────────────────────────────────────┘

App Start
    │
    ▼
┌─────────────┐
│   Splash    │  Check auth state
│   Screen    │
└──────┬──────┘
       │
       ├─────────────┐
       │             │
       ▼             ▼
┌─────────────┐ ┌─────────────┐
│    Not      │ │   Logged    │
│  Authenticated│ │   In        │
│             │ │             │
│ Login/      │ │ Main        │
│ Register    │ │ Navigation  │
└─────────────┘ └──────┬──────┘
                       │
                       ├──────────────────────────────────┐
                       │                                │
                       ▼                                ▼
                ┌──────────────┐              ┌──────────────┐
                │ Bottom Nav   │              │ Center FAB   │
                │   Tabs       │              │   Button     │
                └──────┬───────┘              └──────┬───────┘
                       │                             │
        ┌──────────────┼──────────────┐             │
        │              │              │             │
        ▼              ▼              ▼             ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│    Home     │ │  Dashboard  │ │    Learn    │ │  AI Chat    │
│   Screen    │ │   Screen    │ │   Screen    │ │   Screen    │
└─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
```

**GoRouter Configuration:**

```dart
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    // Auth routes
    GoRoute(path: '/splash', builder: (_, __) => SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => RegistrationScreen()),
    
    // Main app
    GoRoute(
      path: '/',
      builder: (_, __) => MainNavigationScreen(),
      routes: [
        GoRoute(path: 'home', builder: (_, __) => HomeScreen()),
        GoRoute(path: 'dashboard', builder: (_, __) => DashboardScreen()),
        GoRoute(path: 'learn', builder: (_, __) => LearnScreen()),
        GoRoute(path: 'profile', builder: (_, __) => ProfileScreen()),
      ],
    ),
    
    // AI Services (from FAB or Home grid)
    GoRoute(path: 'chat', builder: (_, __) => ChatScreen()),
    GoRoute(path: 'soil-analysis', builder: (_, __) => SoilAnalysisScreen()),
    GoRoute(path: 'pest-detection', builder: (_, __) => PestDetectionScreen()),
    
    // Other screens
    GoRoute(path: 'marketplace', builder: (_, __) => MarketplaceScreen()),
  ],
);
```

---

## AI Integration Architecture

### AI Service 1: Crop Intelligence

```
┌─────────────────────────────────────────────────────────────┐
│              AI CROP INTELLIGENCE SYSTEM                     │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐
│ Soil Analysis│
└──────┬───────┘
       │ Input: NPK values, pH, soil type
       ▼
┌──────────────┐
│   Mobile     │  Capture/Upload
│   Camera     │  Soil Test Report
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Image      │  Preprocessing
│  Processing  │  (OpenCV/TensorFlow Lite)
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    On-Device │  Quick Analysis
│     ML Model │  (Optional caching)
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Cloud API  │  POST /api/v1/ai/analyze-soil
│   Backend    │  Body: { npk, ph, soilType }
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  AI Model    │  Scikit-learn / TensorFlow
│  (Server)    │  Crop recommendation engine
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Response   │  { healthScore, deficiencies,
│   JSON       │    recommendations[] }
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Mobile     │  Display results
│   UI         │  Show actionable insights
└──────────────┘


┌──────────────┐
│ Pest Detection│
└──────┬───────┘
       │ Input: Crop leaf image
       ▼
┌──────────────┐
│   Mobile     │  Take photo of
│   Camera     │  affected crop
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Image      │  Resize, Normalize
│  Preprocess  │  Enhance contrast
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  CNN Model   │  TensorFlow/PyTorch
│  (Cloud)     │  Image classification
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Response   │  { pestName, confidence,
│   JSON       │    treatment[], prevention[] }
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Mobile     │  Show pest info
│   UI         │  Treatment steps
└──────────────┘
```

### AI Service 2: Conversational Assistant

```
┌─────────────────────────────────────────────────────────────┐
│              AI CHAT ASSISTANT SYSTEM                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────┐
│   User      │  "What is the price of soybean?"
│   Types     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Mobile    │  Optimistic UI update
│   Chat UI   │  Show user message
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  WebSocket  │  WS /ws/chat?userId=123
│ Connection  │  Keep-alive connection
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Backend   │  Node.js + Socket.io
│   Server    │  Message routing
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    NLP      │  Hugging Face Transformers
│  Processor  │  Intent recognition
└──────┬──────┘
       │
       ├──────────────────┐
       │                  │
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│   Query     │    │   General   │
│  Database   │    │   Knowledge │
│             │    │   Base      │
│ SELECT price│    │ FAQ answers │
│ FROM market │    │ Farming tips│
└──────┬──────┘    └──────┬──────┘
       │                  │
       └────────┬─────────┘
                │
                ▼
         ┌─────────────┐
         │   Response  │
         │  Generator  │
         └──────┬──────┘
                │
                ▼
         ┌─────────────┐
         │   Stream    │
         │  Response   │
         │  (Chunks)   │
         └──────┬──────┘
                │
                ▼
         ┌─────────────┐
         │   Mobile    │
         │   Chat UI   │
         │ Typing...   │
         └──────┬──────┘
                │
                ▼
         ┌─────────────┐
         │  Full AI    │
         │  Response   │
         │  Displayed  │
         └─────────────┘
```

---

## Database Schema (Future Backend)

```sql
-- Farmers Table
CREATE TABLE farmers (
    id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    email VARCHAR UNIQUE NOT NULL,
    phone VARCHAR,
    location VARCHAR,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Farms Table
CREATE TABLE farms (
    id VARCHAR PRIMARY KEY,
    farmer_id VARCHAR REFERENCES farmers(id),
    location_name VARCHAR,
    latitude DECIMAL,
    longitude DECIMAL,
    area_acres DECIMAL,
    soil_type VARCHAR
);

-- Crops Table
CREATE TABLE crops (
    id VARCHAR PRIMARY KEY,
    farm_id VARCHAR REFERENCES farms(id),
    crop_name VARCHAR NOT NULL,
    variety VARCHAR,
    planting_date DATE,
    expected_harvest DATE,
    status VARCHAR -- 'growing', 'ready', 'harvested'
);

-- Market Prices Table
CREATE TABLE market_prices (
    id VARCHAR PRIMARY KEY,
    crop_name VARCHAR NOT NULL,
    price_per_quintal DECIMAL NOT NULL,
    mandi_location VARCHAR,
    price_date DATE,
    change_percent DECIMAL
);

-- Chat Messages Table
CREATE TABLE chat_messages (
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR REFERENCES farmers(id),
    message_text TEXT NOT NULL,
    is_from_user BOOLEAN,
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Soil Analysis Results Table
CREATE TABLE soil_analyses (
    id VARCHAR PRIMARY KEY,
    farm_id VARCHAR REFERENCES farms(id),
    nitrogen_ppm DECIMAL,
    phosphorus_ppm DECIMAL,
    potassium_ppm DECIMAL,
    ph_level DECIMAL,
    health_score DECIMAL,
    analyzed_at TIMESTAMP DEFAULT NOW()
);
```

---

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT FLOW                           │
└─────────────────────────────────────────────────────────────┘

Development
    │
    ▼
┌─────────────┐
│ Git Repository│  GitHub/GitLab
│   (Source)   │
└──────┬───────┘
       │
       ▼
┌─────────────┐
│   CI/CD     │  GitHub Actions
│   Pipeline  │  Automated testing
└──────┬───────┘
       │
       ├──────────────────┐
       │                  │
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│   Mobile    │    │   Backend   │
│    Apps     │    │   Server    │
│             │    │             │
│ • APK       │    │ • Docker    │
│ • AAB       │    │ • AWS ECS   │
│ • IPA       │    │ • Lambda    │
│ • Web       │    │             │
└─────────────┘    └─────────────┘
       │                  │
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│ Play Store  │    │   Database  │
│ App Store   │    │   RDS/Mongo │
│ Firebase    │    │             │
└─────────────┘    └─────────────┘
```

---

## Security Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────┐
│   Client    │  Flutter App
│   (Mobile)  │
└──────┬──────┘
       │ HTTPS/TLS 1.3
       ▼
┌─────────────┐
│     API     │  JWT Authentication
│   Gateway   │  Rate Limiting
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Auth      │  OAuth 2.0 / JWT
│   Service   │  Token validation
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Business  │  Input validation
│   Logic     │  SQL injection prevention
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Data      │  Encryption at rest
│   Layer     │  Field-level encryption
└─────────────┘

Security Measures:
✓ HTTPS for all API calls
✓ JWT token-based authentication
✓ Encrypted local storage (SharedPreferences)
✓ Input sanitization
✓ SQL injection prevention
✓ Rate limiting on API
✓ CORS configuration
```

---

## Summary

**Kurukshetra** follows a **clean architecture** approach with clear separation of concerns:

1. **Presentation Layer**: Screens and widgets that users interact with
2. **Business Logic Layer**: Riverpod providers managing application state
3. **Data Layer**: Repositories abstracting data sources (API, local storage)

This architecture ensures:
- ✅ **Testability**: Each layer can be tested independently
- ✅ **Maintainability**: Clear boundaries between components
- ✅ **Scalability**: Easy to add new features
- ✅ **Flexibility**: Can swap implementations without affecting other layers
- ✅ **Reusability**: Shared utilities and widgets across features

The app is designed to integrate seamlessly with backend AI services while providing a smooth offline-first experience for farmers with limited connectivity.
