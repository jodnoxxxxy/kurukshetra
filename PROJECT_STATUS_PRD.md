# Kurukshetra — PRD / Implementation Status Report

Legend: ✅ Implemented | 🟡 Half / Mock only | ❌ Not implemented

## 1. Project Overview
Smart-farming app for Indian farmers (crop advisory, pest/disease detection, soil health, market prices, fertilizer calculator, warehouse, consumer marketplace, chat). Stack: Flutter frontend, Node.js/Express backend, Firebase, Python ML.

## 2. Frontend Features (`frontend/lib/features`)
| Module | Status | Notes |
|---|---|---|
| splash | ✅ | Splash screen exists |
| auth | 🟡 | Login/register/role selection screens; services exist but some registration methods are stubs (`saveFarmerRegistration` returns void) |
| home / dashboard | ✅ | Dashboard screen present |
| farmer | 🟡 | Farmer module present |
| consumer_auth | 🟡 | Consumer model/provider/repository/screens present |
| consumer / marketplace / cart / checkout / orders / product_details | 🟡 | Full UI screens exist; repositories talk to API but not fully wired/verified end-to-end |
| consumer_dashboard / consumer_profile | 🟡 | UI present |
| crop_advisory | 🟡 | Input/recommendation/timeline screens, provider + widgets present |
| ai (crop/pest/soil) | 🟡 | Screens, providers, repositories present; results depend on backend AI endpoints |
| pest_disease | 🟡 | UI present |
| fertilizer_calculator / calculator | 🟡 | Screens + provider present (local SharedPreferences storage); one broken compat shim deleted |
| market_prices | 🟡 | Screens present |
| climate_advisory + climate_technology | 🟡 | Duplicated module pair (two models/providers/screens) |
| chat / messaging | 🟡 | Chat screens + provider + repository; backend Gemini service used |
| warehouse | 🟡 | Screen present |
| dbt / sop / learn / support | 🟡 | Info/screens present |
| admin | 🟡 | Admin login/dashboard/upload screens present |
| navigation / profile / integration | 🟡 | Present |

## 3. Backend (`backend/src`)
| Area | Status | Notes |
|---|---|---|
| Auth (JWT + OTP + Firebase) | 🟡 | JWT, OTP service, Firebase user service exist; mock-token bypass (now disabled in prod); only auth tests exist |
| User / Farm / Farmer controllers | 🟡 | Controllers + services exist; user.service, farm.direct duplicated |
| Market / Orders / Notifications / Disease / Monitoring | 🟡 | Controllers + services exist; not covered by tests |
| Inspections (crop check workflow) | 🟡 | Route file inspections.js (13 KB) exists |
| AI routes (`ai.js` 20 KB) | 🟡 | Many endpoints; calls external AI URLs (env-configured) |
| Chat service | 🟡 | Gemini integration working; API key now env-only |
| Climate, Cost calculator, Fertilizer, Pest, Scheme, Soil, Warehouse | 🟡 | Controllers + services + routes exist; many duplicated `*.refactored.js` / `*.direct.js` variants not cleaned |
| Socket.IO chat | 🟡 | `src/sockets/index.js` present |
| Prisma + SQLite dev DB | 🟡 | schema + migrations exist; production DB not configured |
| Rate limiting, helmet, CORS, compression, logging | ✅ | Present in app.js |
| Backend tests | 🟡 | Only `tests/auth.test.js`; no coverage for 15+ other modules |

## 4. AI / ML (`ai_ml/`)
| Item | Status | Notes |
|---|---|---|
| Crop recommendation model | 🟡 | `models/crop_recommendation.py` script exists; trained model/artifact status unknown |
| Disease detection | 🟡 | `disease_detection.py` exists |
| Yield prediction | 🟡 | `yield_prediction.py` exists |
| Weather analysis | 🟡 | `weather_analysis.py` exists |
| Data preprocessing | 🟡 | `scripts/preprocess_data.py`; notebooks present |
| Serving / deployment of ML models | ❌ | No API server or integration verified; backend AI routes point to env URLs |

## 5. Database
| Item | Status |
|---|---|
| Firebase Firestore + rules | 🟡 (rules file present) |
| Firestore seed script | 🟡 (`database/firestore_seed.json`, scripts) |
| Prisma schema + migrations | 🟡 |
| PostgreSQL production DB | ❌ (only SQLite dev.db) |

## 6. Testing
| Item | Status |
|---|---|
| Backend jest tests | 🟡 1 file |
| Frontend widget/unit tests | 🟡 several files (mostly mock/validation) |
| Integration/E2E tests | ❌ |
| CI test automation | ❌ |

## 7. DevOps / Deployment
| Item | Status |
|---|---|
| Dockerfile + docker-compose | 🟡 present but unverified |
| PM2 ecosystem config | 🟡 present |
| Firebase hosting config | 🟡 (firebase.json present) |
| CI/CD (GitHub Actions) | ❌ |
| Release APK | 🟡 built artifact exists (92 MB committed at root — should be removed) |

## 8. Security / Hygiene
| Item | Status |
|---|---|
| No hard-coded secrets in source | 🟡 (Gemini key removed; verify git history) |
| firebase-credentials.json untracked+ignored | ✅ |
| Mock-token auth bypass disabled in prod | ✅ |
| CORS restricted | 🟡 (localhost allowed in dev only) |
| No committed APK/logs/db in git | 🟡 (db artifacts removed from index; APK is ignored but present on disk) |

## 9. Half / Remaining Summary
- **Half-done UI wiring:** most feature screens built, but end-to-end API wiring not verified for consumer marketplace, chat, warehouse, climate, etc.
- **Duplication debt:** `climate_advisory` vs `climate_technology`, `*.refactored.js` vs original routes, `*.direct.js` services, two Flutter projects in repo root
- **Testing:** almost no backend tests; no E2E; no CI
- **ML serving:** Python models written but not integrated/deployed
- **Production DB:** PostgreSQL not set up; still SQLite dev.db
- **Analysis debt:** 39 `flutter analyze` warnings remain (deprecated APIs, unused items)
- **Dependencies:** duplicates (http+dio, bcrypt+bcryptjs, provider+riverpod+hooks_riverpod) not pruned
- **Docs:** multiple overlapping docs; no single setup README flow

## 10. To call it "done / industry level"
- [ ] Remove committed APK/logs; rotate exposed keys
- [ ] Consolidate duplicate modules and deps
- [ ] Backend test coverage + Jest thresholds
- [ ] E2E + CI pipeline (analyze, lint, test, build)
- [ ] Production PostgreSQL + migrations
- [ ] Deploy/serve ML models behind an API
- [ ] Centralized error handling + validated env config
- [ ] Rate-limit auth/OTP endpoints; enable Firebase App Check
- [ ] Clean README + canonical docs
