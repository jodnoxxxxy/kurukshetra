# Kurukshetra — Software Engineering Review Report

Date: 2026-10-04
Scope: Repository root (`C:\Users\ShreyashDalvi\kurukshetra`) — Flutter frontend (`frontend/`), Node.js/Express backend (`backend/`), AI/ML (`ai_ml/`), database (`database/`).

## How the review was performed (steps)
1. Mapped repository structure and stack (Flutter 3.9, Riverpod 3, go_router, Firebase; Node.js 5/Express 5, Prisma, Socket.IO; Python/TF for ML).
2. Reviewed config, middleware, controllers, services, and routes for correctness/security against standard SE rules (SOLID, security, DRY, error handling, testing, CI/CD, repo hygiene).
3. Ran `flutter analyze` on the frontend (49 issues) and enumerated backend test coverage.
4. Checked git status/ignore for secrets and build artifacts.
5. Catalogued bugs, faults, and improvement items below with file references.

---

## 1. Bugs (functional defects)

| # | Location | Bug | Evidence / Impact |
|---|----------|-----|-------------------|
| B1 | `frontend/lib/features/calculator/providers/riverpod_compat.dart:2` | Re-exports `StateNotifier`, `StateNotifierProvider`, `StateProvider` from `flutter_riverpod` v3 where they no longer exist | `flutter analyze`: "The library ... doesn't export a member with the shown name" — calculator feature is built on a broken compatibility shim |
| B2 | `frontend/lib/features/auth/services/firebase_user_service.dart:14` | Unused `_getUserId` | Dead code warning; indicates leftover refactor |
| B3 | Multiple screens | Deprecated `value:` on form fields (should be `initialValue`), `withOpacity` (should be `.withValues`), geolocator `timeLimit` deprecated | `flutter analyze`: ~20 deprecated-member warnings across `manual_crop_check_screen.dart`, `register_screen.dart`, `cost_calculator_screen.dart`, `expense_screen.dart`, `climate_*`, `crop_advisory_*`, `climate_service.dart` — will break on SDK upgrade |
| B4 | `frontend/lib/core/routing/app_router.dart:57,74` | Unused imports of `climate_advisory_screen.dart`, `cost_calculator_screen.dart` | Stale routes/imports; router file is 17 KB monolith |
| B5 | `backend/src/config/index.js` | `JWT_SECRET`, `JWT_REFRESH_SECRET` may be `undefined`; middleware falls back `process.env.JWT_SECRET || config.JWT_SECRET` | `jwt.verify(token, undefined)` throws/weak auth — fail-open risk at runtime |
| B6 | `backend/src/routes/*.refactored.js` vs original (e.g. `cost-calculator.js`, `fertilizer.js`, `pest-detection.js`, `schemes.js`, `soil-health.js`, `warehouse.js`, `market-new.js`) | Parallel duplicate route/service files (`*.direct.js`, `*.refactored.js`, `market-new.js`) | Dead/duplicated code paths; easy to mount the wrong one — maintenance fault |
| B7 | `frontend/lib` | Two `climate_model.dart`, two `climate_advisory_screen.dart`, two `climate_provider.dart` (features `climate_advisory` vs `climate_technology`) | Duplicated feature modules with confusing naming |
| B8 | Backend tests | Only one test file exists: `backend/tests/auth.test.js` (`npx jest --listTests` → 1 test) | No coverage for the other 15+ controllers/services |
| B9 | `frontend/test/module_tests.dart` | Unused local variables, unnecessary type checks | Test code quality warnings |

## 2. Security faults (must fix)

| # | Location | Fault |
|---|----------|-------|
| S1 | `backend/src/services/chat.service.js:31` | Live Gemini API key hard-coded as fallback: `process.env.GEMINI_API_KEY || 'AIzaSy...'` — secret committed to source |
| S2 | `backend/firebase-credentials.json` | Firebase service-account JSON present in repo and **not** git-ignored (`git check-ignore` fails for it) |
| S3 | `backend/src/middleware/auth.js:28-31` | `mock_token_*` / `demo_*` tokens are accepted unconditionally, in any environment — full auth bypass if reachable in prod |
| S4 | `backend/src/app.js:58` | CORS allows **any** `http://localhost:*` origin plus hard-coded ports — overly permissive |
| S5 | `backend/dev.db`, `backend/src/dev.db`, WAL/SHM files | SQLite dev databases tracked in the working tree (some git-tracked); dev data may leak |
| S6 | `backend/.env` | Untracked (good) but present; ensure it is never committed — add CI secret-scan |
| S7 | Firebase API keys in `frontend/lib/firebase_options.dart`, `frontend/web/firebase-messaging-sw.js` | Expected for Firebase web, but verify Firebase App Check + restrict keys in console |
| S8 | Global rate limit 100 req/15 min per IP on all `/api/` | May be too strict for a mobile app burst; also no per-route stricter limits on auth/OTP endpoints |

## 3. Structural / engineering-practice issues

1. **Repo hygiene**: 92 MB `kurukshetra-updated-release.apk` committed at root; `build_error.log` (1.2 MB), `test_output.txt`, `server.log`, `temp_router.txt`, `patch.js`, `backend_patch.js` committed; `deleted` legacy docs left in git.
2. **Root `frontend/lib` duplication risk**: root `pubspec.yaml`/`.dart_tool`/`build/` exist at repo root alongside `frontend/` — two Flutter projects in one repo.
3. **No CI/CD**: no `.github/workflows`; only manual scripts (`setup.bat`, `start-server.bat`, Postman collections).
4. **Testing**: backend has 1 test file; frontend tests exist but many are mock/validation-only. No integration tests, no coverage thresholds.
5. **Error handling**: controllers duplicate try/catch blocks; no centralized async error wrapper; `verifyToken` swallows errors and returns `null`.
6. **Config**: secrets read ad-hoc from `process.env` in services (chat.service.js, otp, etc.) instead of `config/index.js`; no validation of required env at boot.
7. **Architecture**: 17 KB `app_router.dart`, 20 KB `ai.js` route file, 18 KB `pest.service.js`, 16 KB `scheme.service.js`, 15 KB `farmers.js` — large files violating SRP; mix of Riverpod + Provider + hooks_riverpod in one app.
8. **Dependencies**: both `bcrypt` and `bcryptjs`, both `http` and `dio`, both `provider` and `flutter_riverpod` + `hooks_riverpod` — redundant deps increase attack surface and binary size.
9. **Docs**: many overlapping docs at root (`QUICK_REFERENCE.md` in 2 places, `PROJECT_STATUS.md`, `SYSTEM_ARCHITECTURE.md`) — no single authoritative README flow.

## 4. What to improve (prioritized)

**P0 (this week)**
- Remove the hard-coded Gemini key (S1), rotate it, move to env, add `dotenv` validation at startup (S6).
- Delete/mock-token guard in `auth.js` middleware — allow `mock_token_` only when `NODE_ENV !== 'production'` (S3).
- Git-ignore `firebase-credentials.json`, `*.db*`, `*.log`, `*.apk`, `build/`; rotate Firebase keys if leaked (S2, S5).
- Fix `riverpod_compat.dart` (B1) — replace with `StateNotifierProvider` from `flutter_riverpod` legacy or migrate calculator to `NotifierProvider`.

**P1 (2–4 weeks)**
- Delete duplicate `*.refactored.js` / `*.direct.js` / duplicate `climate_advisory` vs `climate_technology` modules; keep one canonical implementation (B6, B7).
- Run `flutter analyze` clean (49 → 0): fix unused imports, deprecated APIs (B3, B4).
- Add backend tests for auth edge cases, and add Jest coverage threshold; wire frontend tests into CI (B8).
- Add GitHub Actions: `flutter analyze && flutter test`, `eslint src/ && jest`, build APK (E3).

**P2 (ongoing)**
- Split `app_router.dart` and `ai.js` into per-feature route/config modules.
- Consolidate state management on one Riverpod flavor; drop `provider`/`hooks_riverpod`.
- Add centralized API error model + request validation middleware; stricter rate limits on `/auth` and `/otp`.
- Trim dependencies (drop one of http/dio, bcrypt/bcryptjs).
- Refresh README with single-command setup, architecture diagram link, and env config table.

## 5. Verification summary
- `flutter analyze` (frontend): 49 issues — 1 broken Riverpod export, ~20 deprecations, ~15 unused imports/elements, rest info-level.
- `npx jest --listTests` (backend): 1 test file only.
- `git check-ignore`: `firebase-credentials.json` and SQLite dev DBs are NOT ignored.
- grep for secrets: found live Gemini API key fallback in `chat.service.js`.

Prepared as a static review + tooling output. Recommend fixing P0 items before any production release.
