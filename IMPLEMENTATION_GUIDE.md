# 🚀 IMPLEMENTATION GUIDE - SMART FARMING AI APPLICATION

## Phase 2: Backend Controllers & Frontend Integration

---

## 📋 BACKEND ROUTES & CONTROLLERS

### API Endpoints Structure

All endpoints follow RESTful convention:
```
/api/v1/{module}/{action}
```

---

## 1. CROP ADVISORY ROUTES

**File:** `backend/src/routes/crop.js`

```javascript
// GET /api/v1/crop/recommendations
// Request: { season, temperature, soilType, rainfall, waterAvailability }
// Response: { recommendations: [...], season, location, message }

// GET /api/v1/crop/{cropName}/steps
// Request: { cropName, season }
// Response: { steps: [...], duration, expectedYield, costPerAcre }

// POST /api/v1/crop/validate-input
// Validates user input before processing
```

**Controller:** `backend/src/controllers/crop.controller.js`

```javascript
// cropController.getRecommendations(req, res)
// cropController.getDetailedSteps(req, res)
// cropController.validateCropInput(req, res)
```

---

## 2. FERTILIZER CALCULATOR ROUTES

**File:** `backend/src/routes/fertilizer.js`

```javascript
// POST /api/v1/fertilizer/calculate
// Request: { crop, landArea, soilNutrients: {N, P, K} }
// Response: { cropRequirement, fertilizer, recommendations, timing, ... }

// GET /api/v1/fertilizer/nutrient/{nutrient}
// Returns detailed nutrient information

// POST /api/v1/fertilizer/compare
// Compare multiple fertilizer options
```

**Controller:** `backend/src/controllers/fertilizer.controller.js`

```javascript
// fertilizerController.calculateRequirement(req, res)
// fertilizerController.getNutrientInfo(req, res)
// fertilizerController.compareFertilizers(req, res)
```

---

## 3. COST CALCULATOR ROUTES

**File:** `backend/src/routes/cost.js`

```javascript
// POST /api/v1/cost/calculate
// Request: { crop, landArea, costs?: {...} }
// Response: { costBreakdown, expectedYield, profitAnalysis, roi, ... }

// POST /api/v1/cost/compare
// Request: { crops: [...], landArea }
// Response: Comparative analysis across crops

// GET /api/v1/cost/optimization/{crop}
// Suggestions for cost reduction
```

**Controller:** `backend/src/controllers/cost.controller.js`

```javascript
// costController.calculateCost(req, res)
// costController.compareCreops(req, res)
// costController.optimizeCost(req, res)
```

---

## 4. SOIL HEALTH ROUTES

**File:** `backend/src/routes/soil.js`

```javascript
// POST /api/v1/soil/analyze
// Request: { pH, nitrogen, phosphorus, potassium, organicMatter, ec, crop }
// Response: { healthScore, macroNutrientAnalysis, improvements, actionPlan, ... }

// GET /api/v1/soil/standards/{crop}
// Get soil standards for specific crop

// POST /api/v1/soil/improvement-plan
// Generate detailed improvement roadmap
```

**Controller:** `backend/src/controllers/soil.controller.js`

```javascript
// soilController.generateHealthCard(req, res)
// soilController.getStandards(req, res)
// soilController.getImprovementPlan(req, res)
```

---

## 5. MARKET PRICE ROUTES

**File:** `backend/src/routes/market.js`

```javascript
// GET /api/v1/market/prices/{crop}
// Query: { latitude, longitude, radius }
// Response: { marketPrices: [...], analysis, trends, recommendation }

// POST /api/v1/market/compare
// Request: { crops: [...], latitude, longitude }
// Response: Price comparison across crops

// POST /api/v1/market/alert
// Set up price alerts for crops
```

**Controller:** `backend/src/controllers/market.controller.js`

```javascript
// marketController.getPrices(req, res)
// marketController.comparePrices(req, res)
// marketController.setupAlert(req, res)
```

---

## 6. GOVERNMENT SCHEMES ROUTES

**File:** `backend/src/routes/scheme.js`

```javascript
// POST /api/v1/scheme/find
// Request: { landSize, age, state, crop }
// Response: { schemes: [...], matchScore, priority }

// GET /api/v1/scheme/{schemeId}
// Get detailed scheme information

// GET /api/v1/scheme/{schemeId}/application-steps
// Steps to apply for scheme
```

**Controller:** `backend/src/controllers/scheme.controller.js`

```javascript
// schemeController.findSchemes(req, res)
// schemeController.getSchemeDetails(req, res)
// schemeController.getApplicationSteps(req, res)
```

---

## 7. WAREHOUSE ROUTES

**File:** `backend/src/routes/warehouse.js`

```javascript
// POST /api/v1/warehouse/search
// Request: { latitude, longitude, quantity, duration, crop }
// Response: { warehouses: [...], suitabilityScore, totalCost, ... }

// POST /api/v1/warehouse/book
// Request: { warehouseId, quantity, duration, farmerId }
// Response: { bookingId, confirmation, nextSteps }

// GET /api/v1/warehouse/booking/{bookingId}
// Get booking details and tracking

// POST /api/v1/warehouse/withdraw
// Withdraw stored goods
```

**Controller:** `backend/src/controllers/warehouse.controller.js`

```javascript
// warehouseController.searchWarehouses(req, res)
// warehouseController.bookStorage(req, res)
// warehouseController.getBookingDetails(req, res)
// warehouseController.withdrawStorage(req, res)
```

---

## 8. PEST DETECTION ROUTES

**File:** `backend/src/routes/pest.js`

```javascript
// POST /api/v1/pest/detect
// Request: { imageBase64, crop }
// Response: { detected, disease, confidence, treatment, recommendations }

// GET /api/v1/pest/disease/{diseaseId}
// Get detailed disease information

// POST /api/v1/pest/treatment-plan
// Request: { diseaseId }
// Response: { treatmentPlan: [...], timeline, costEstimate }
```

**Controller:** `backend/src/controllers/pest.controller.js`

```javascript
// pestController.analyzeImage(req, res)
// pestController.getDiseaseDetails(req, res)
// pestController.getTreatmentPlan(req, res)
```

---

## 9. CLIMATE ADVISORY ROUTES (EXISTING)

**File:** `backend/src/routes/climate.js`

```javascript
// GET /api/v1/climate/advisory
// Query: { latitude, longitude }
// Response: { weatherData, riskAnalysis, alerts, advisory }
```

---

## 📱 FRONTEND IMPLEMENTATION STRUCTURE

### Directory Structure

```
frontend/lib/
├── features/
│   ├── crop_advisory/
│   │   ├── models/
│   │   │   ├── crop_model.dart
│   │   │   └── recommendation_model.dart
│   │   ├── providers/
│   │   │   ├── crop_provider.dart
│   │   │   └── crop_recommendation_provider.dart
│   │   ├── services/
│   │   │   └── crop_service.dart
│   │   ├── screens/
│   │   │   ├── crop_input_screen.dart
│   │   │   ├── crop_recommendation_screen.dart
│   │   │   └── crop_detail_screen.dart
│   │   └── widgets/
│   │       ├── crop_card.dart
│   │       ├── recommendation_card.dart
│   │       └── farming_timeline.dart
│   │
│   ├── fertilizer_calculator/
│   │   ├── models/
│   │   │   └── fertilizer_model.dart
│   │   ├── providers/
│   │   │   └── fertilizer_provider.dart
│   │   ├── services/
│   │   │   └── fertilizer_service.dart
│   │   ├── screens/
│   │   │   ├── soil_input_screen.dart
│   │   │   └── fertilizer_recommendation_screen.dart
│   │   └── widgets/
│   │       └── fertilizer_card.dart
│   │
│   ├── cost_calculator/
│   │   ├── models/
│   │   │   └── cost_model.dart
│   │   ├── providers/
│   │   │   └── cost_provider.dart
│   │   ├── screens/
│   │   │   └── cost_analysis_screen.dart
│   │   └── widgets/
│   │       └── cost_breakdown_chart.dart
│   │
│   ├── soil_health/
│   │   ├── models/
│   │   │   └── soil_model.dart
│   │   ├── providers/
│   │   │   └── soil_provider.dart
│   │   ├── screens/
│   │   │   └── soil_health_screen.dart
│   │   └── widgets/
│   │       ├── health_score_card.dart
│   │       └── nutrient_indicator.dart
│   │
│   ├── market_price/
│   │   ├── models/
│   │   │   └── market_model.dart
│   │   ├── providers/
│   │   │   └── market_provider.dart
│   │   ├── screens/
│   │   │   └── market_price_screen.dart
│   │   └── widgets/
│   │       ├── price_card.dart
│   │       └── trending_chart.dart
│   │
│   ├── schemes/
│   │   ├── models/
│   │   │   └── scheme_model.dart
│   │   ├── providers/
│   │   │   └── scheme_provider.dart
│   │   ├── screens/
│   │   │   └── scheme_list_screen.dart
│   │   └── widgets/
│   │       └── scheme_card.dart
│   │
│   ├── warehouse/
│   │   ├── models/
│   │   │   └── warehouse_model.dart
│   │   ├── providers/
│   │   │   └── warehouse_provider.dart
│   │   ├── screens/
│   │   │   └── warehouse_booking_screen.dart
│   │   └── widgets/
│   │       └── warehouse_card.dart
│   │
│   └── pest_detection/
│       ├── models/
│       │   └── pest_model.dart
│       ├── providers/
│       │   └── pest_provider.dart
│       ├── services/
│       │   └── image_service.dart
│       ├── screens/
│       │   ├── image_capture_screen.dart
│       │   └── pest_result_screen.dart
│       └── widgets/
│           └── disease_card.dart
│
├── core/
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── location_service.dart
│   │   ├── cache_service.dart
│   │   └── error_handler.dart
│   ├── models/
│   │   └── api_response.dart
│   └── constants/
│       └── app_constants.dart
│
└── main.dart
```

---

## 🎯 FRONTEND SERVICE PATTERN

Each module follows this pattern:

### 1. Model (Data Structure)

```dart
// Example: crop_model.dart
class CropRecommendation {
  final String cropName;
  final int score;
  final List<String> reasons;
  final Duration duration;
  final int expectedYield;
  
  // toJson() and fromJson() methods
}
```

### 2. Service (API Communication + Caching)

```dart
// Example: crop_service.dart
class CropService {
  static const String baseUrl = '/api/v1/crop';
  
  Future<CropRecommendationsResponse> getRecommendations({
    required double temperature,
    required String soilType,
    required double rainfall,
    required int waterAvailability,
  }) async {
    // Validation
    // API call with error handling
    // Caching logic
    // Fallback to cache on failure
  }
}
```

### 3. Provider (State Management)

```dart
// Example: crop_provider.dart
final cropRecommendationProvider = FutureProvider.autoDispose.family<
  CropRecommendationsResponse,
  CropRecommendationParams
>((ref, params) async {
  final service = ref.watch(cropServiceProvider);
  return service.getRecommendations(
    temperature: params.temperature,
    soilType: params.soilType,
    // ... other params
  );
});
```

### 4. Screen (UI Display)

```dart
// Example: crop_recommendation_screen.dart
class CropRecommendationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(cropRecommendationProvider(params));
    
    return recommendations.when(
      data: (data) => ListView(...),
      error: (err, stack) => ErrorWidget(...),
      loading: () => LoadingWidget(),
    );
  }
}
```

---

## 🔗 INTEGRATION CHECKLIST

### Backend Setup
- [ ] Create all 9 route files in `backend/src/routes/`
- [ ] Create matching controller files
- [ ] Connect routes to `backend/src/app.js` main router
- [ ] Test each route with Postman/ThunderClient
- [ ] Set up proper error handling middleware
- [ ] Add request validation middleware

### Frontend Setup
- [ ] Create model classes for each module
- [ ] Create service classes with API integration
- [ ] Create Riverpod providers for state management
- [ ] Build UI screens for each module
- [ ] Add navigation between screens
- [ ] Implement offline caching
- [ ] Add error handling and retry logic

### Testing
- [ ] Unit tests for services
- [ ] Widget tests for UI screens
- [ ] Integration tests for API calls
- [ ] End-to-end testing across all modules

---

## 📊 DATA FLOW EXAMPLE: CROP RECOMMENDATION

```
User Input Screen
    ↓
crop_provider.getRecommendations(params)
    ↓
crop_service.getRecommendations()
    ↓
Validate Input ← [Error: Invalid Input] → Show Error
    ↓
API Call: POST /api/v1/crop/recommendations
    ↓
Backend Service: cropAdvisoryService.generateSmartCropRecommendations()
    ↓
Database Lookup + Scoring Algorithm
    ↓
Response: { recommendations: [...] }
    ↓
Cache to SharedPreferences
    ↓
Parse to CropRecommendation Models
    ↓
Provider Update
    ↓
UI Rebuild: Display Recommendations
    ↓
User Selects Crop → Fetch Steps
    ↓
API Call: GET /api/v1/crop/{cropName}/steps
    ↓
Backend Service: getDetailedSteps()
    ↓
Response: { steps: [...], duration, yield, ... }
    ↓
UI: Display Crop Detail Screen with Timeline
```

---

## 🛠️ COMMON PATTERNS

### Error Handling Pattern

```dart
// In services
Future<T> callAPI<T>(...) async {
  try {
    final response = await http.post(...).timeout(Duration(seconds: 15));
    
    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      throw ApiException(code: response.statusCode);
    }
  } on SocketException {
    // Network error - try cache
    return getCached();
  } on TimeoutException {
    // Timeout - fallback to cache
    return getCachedOrThrow();
  } catch (e) {
    throw ApiException(message: e.toString());
  }
}
```

### Caching Pattern

```dart
Future<T> fetchWithCache<T>({
  required Future<T> Function() fetcher,
  required T Function() getter,
  required void Function(T) setter,
  Duration ttl = const Duration(minutes: 15),
}) async {
  final cached = getter();
  final timestamp = _getCacheTime();
  
  if (cached != null && DateTime.now().difference(timestamp).inMinutes < 15) {
    return cached;
  }
  
  try {
    final fresh = await fetcher();
    setter(fresh);
    return fresh;
  } catch (e) {
    if (cached != null) return cached;
    rethrow;
  }
}
```

### Retry Pattern

```dart
Future<T> withRetry<T>({
  required Future<T> Function() fn,
  int maxAttempts = 3,
  Duration delay = const Duration(seconds: 2),
}) async {
  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (e) {
      if (attempt == maxAttempts) rethrow;
      await Future.delayed(delay * attempt); // Exponential backoff
    }
  }
}
```

---

## 📦 DEPLOYMENT CHECKLIST

- [ ] All services tested independently
- [ ] All routes tested with sample data
- [ ] All screens responsive on mobile/tablet
- [ ] Error messages user-friendly
- [ ] Offline mode working
- [ ] Performance optimized (< 3s load time)
- [ ] API versioning in place
- [ ] Security headers added
- [ ] CORS properly configured
- [ ] Logging and monitoring set up
- [ ] Database backups configured
- [ ] Production environment variables set

---

## 📞 NEXT STEPS

1. **Phase 2A:** Create all backend controllers and routes
2. **Phase 2B:** Implement frontend models and services
3. **Phase 2C:** Build UI screens for each module
4. **Phase 3:** Integration testing and debugging
5. **Phase 4:** Performance optimization
6. **Phase 5:** Deployment to production

---

**Status:** Architecture complete. Ready for implementation.
