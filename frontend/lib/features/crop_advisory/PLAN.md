# Implementation Plan - Crop Advisory System

## Overview
Build a comprehensive "Crop Advisory System" for the Kurukshetra app, enabling farmers to get data-driven crop recommendations and growth timelines.

## Tech Stack
- **Frontend**: Flutter (Riverpod for state management)
- **APIs**: Geolocator (location), OpenWeatherMap (weather)
- **UI Architecture**: Feature-based organization in `frontend/lib/features/crop_advisory`

## File Structure
`frontend/lib/features/crop_advisory/`
- `models/`
  - `crop_recommendation.dart`
  - `growth_step.dart`
  - `soil_data.dart`
- `repositories/`
  - `crop_advisory_repository.dart` (Weather and Recommendation logic)
- `providers/`
  - `crop_advisory_provider.dart`
- `screens/`
  - `crop_input_screen.dart` (Soil, Water input)
  - `crop_recommendation_screen.dart` (Top 3 crops)
  - `crop_timeline_screen.dart` (Step-by-step process)
- `widgets/`
  - `weather_card.dart`
  - `recommendation_card.dart`
  - `timeline_indicator.dart`

## Workflow Implementation
1. **User Input Module**: Form with dropdowns for Soil Type and Water Availability.
2. **Auto Data Fetch Module**: Integration with `geolocator` and OpenWeatherMap API.
3. **Data Analysis Module**: Logic to determine season and filter crops based on conditions.
4. **Crop Recommendation Engine**: Heuristic engine (to be replaced with AI later) recommending top 3 crops.
5. **Growth Timeline Module**: Pre-defined stages (Sowing to Harvest) for recommended crops.
6. **Advisory Module**: Tips and expert contact option.

## Premium UI Elements
- Glassmorphic weather card.
- Animated transitions between steps.
- Modern icons (FontAwesome).
- Responsive layout for different screen sizes.
