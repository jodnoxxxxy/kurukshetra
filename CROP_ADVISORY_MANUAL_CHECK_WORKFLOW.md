# Crop Advisory Workflow with Manual Crop Check

## Overview
This document describes the complete crop advisory workflow in Kurukshetra, including the new **Manual Crop Check** feature that allows farmers to manually inspect their crops and integrate the findings into the advisory system.

## Workflow Architecture

### 1. Main Flow
```
Farmer Selection → Advisory Timeline → Manual Crop Check (NEW) → Health Assessment → Advisory Recommendations
```

### 2. Components

#### A. Crop Advisory Timeline (`advisory_timeline_screen.dart`)
- Displays growth stages and AI-generated recommendations
- Shows real-time weather data
- Tracks crop progress from Day 1 to harvest
- Integration point for manual inspections

#### B. Manual Crop Check Screen (`manual_crop_check_screen.dart`)
**Purpose**: Allow farmers to perform visual health inspections of their crops

**Key Features**:
- Health Status Assessment (Healthy, Stressed, Diseased, Critical)
- Leaf Condition Monitoring (Yellowing, Wilting, Damaged)
- Pest & Disease Detection
- Soil & Water Management Tracking
- Photo Evidence Capture
- Automatic Risk Level Calculation

**Data Collected**:
| Field | Type | Purpose |
|-------|------|---------|
| Health Status | Enum | Overall crop health |
| Leaf Condition | Enum | Visual leaf assessment |
| Soil Condition | Enum | Soil state evaluation |
| Moisture Level | Enum | Water availability |
| Crop Height | Float | Growth tracking |
| Pests/Diseases | Text | Disease identification |
| Issues | Text | Problem description |
| Recommendation | Text | Farmer suggested action |
| Image | URL | Photo evidence |

#### C. Inspection Results Screen (`inspection_results_screen.dart`)
- Displays inspection history for a field
- Shows summary statistics
- Timeline view of all inspections
- Detailed inspection analysis

#### D. Backend API (`routes/inspections.js`)
**Endpoints**:
```
POST   /api/v1/inspections                           # Create inspection
GET    /api/v1/inspections/field/:fieldId            # Get field inspections
GET    /api/v1/inspections/field/:fieldId/latest     # Get latest inspection
GET    /api/v1/inspections/:id                       # Get inspection details
PUT    /api/v1/inspections/:id                       # Update inspection
DELETE /api/v1/inspections/:id                       # Delete inspection
GET    /api/v1/inspections/summary/farm/:farmId      # Get farm summary
```

#### E. Database Model (`CropInspection`)
```prisma
model CropInspection {
  id                String     @id @default(cuid())
  fieldId           String     (relation to Field)
  cropId            String     (relation to Crop)
  healthStatus      String?    (HEALTHY, STRESSED, DISEASED, CRITICAL)
  leafCondition     String?    (HEALTHY, YELLOWING, WILTING, DAMAGED, OTHER)
  soilCondition     String?    (GOOD, AVERAGE, POOR, WATERLOGGED, DRY)
  moistureLevel     String?    (WET, ADEQUATE, DRY, VERY_DRY)
  cropHeight        Float?     (cm)
  leafColor         String?    (GREEN, PALE_GREEN, YELLOW, RED, BROWN)
  pests             String?    (comma-separated list)
  diseases          String?    (comma-separated list)
  issues            String?    (free-form description)
  recommendation    String?    (farmer notes)
  actionRequired    Boolean?   (flag for urgent action)
  riskLevel         String?    (LOW, MEDIUM, HIGH, CRITICAL)
  imageUrl          String?    (photo of crop)
  inspectedAt       DateTime   (when inspection was done)
  createdAt         DateTime
  updatedAt         DateTime
  deletedAt         DateTime?  (soft delete)
}
```

## User Journey

### For Farmers
1. **View Crop Advisory**: Navigate to crop advisory timeline
2. **Perform Manual Check**: Tap "Manual Crop Check" button
3. **Assessment Form**: Fill out visual health assessment
4. **Photo Capture**: Take photo of crop for evidence
5. **Submit**: Record the inspection
6. **View History**: See all past inspections and trends
7. **Get Recommendations**: Receive AI-based advisory based on findings

### Risk Level Calculation
The system automatically calculates risk levels:
- **CRITICAL**: Health status is CRITICAL or DISEASED with visible damage
- **HIGH**: Health status is STRESSED
- **MEDIUM**: Leaf condition is DAMAGED or WILTING
- **LOW**: Health status is HEALTHY or normal conditions

## Integration with AI System

### Prediction Generation
When an inspection is marked as non-healthy, the system automatically generates a prediction:
```json
{
  "type": "INSPECTION_BASED",
  "confidence": 0.85,
  "recommendation": "Monitor crop closely and take appropriate action"
}
```

## Data Flow

```
Manual Inspection Form
        ↓
Backend Inspection API
        ↓
Database Store (CropInspection)
        ↓
Prediction Generator
        ↓
Advisory System
        ↓
Farmer Notification
```

## API Request Example

### Create Inspection
```bash
POST /api/v1/inspections
Content-Type: application/json

{
  "fieldId": "field_123",
  "cropId": "crop_456",
  "healthStatus": "STRESSED",
  "leafCondition": "YELLOWING",
  "soilCondition": "DRY",
  "moistureLevel": "DRY",
  "cropHeight": 45.5,
  "leafColor": "YELLOW",
  "pests": "Aphids, Mites",
  "diseases": null,
  "issues": "Leaves showing yellowing at edges",
  "recommendation": "Apply neem oil spray and increase watering",
  "actionRequired": true,
  "wateringNeeded": true,
  "imageUrl": "path/to/image.jpg",
  "notes": "Spotted yellowing on lower leaves"
}
```

### Response
```json
{
  "success": true,
  "data": {
    "id": "insp_123",
    "fieldId": "field_123",
    "cropId": "crop_456",
    "healthStatus": "STRESSED",
    "riskLevel": "HIGH",
    "inspectedAt": "2024-04-08T10:30:00Z",
    "prediction": {
      "type": "INSPECTION_BASED",
      "confidence": 0.85
    }
  },
  "message": "Inspection recorded successfully"
}
```

## Navigation Structure

```
CropAdvisoryTimeline
├── Manual Crop Check Button ← NEW
│   └── ManualCropCheckScreen (fieldId, cropId)
│       └── Submit
│           └── InspectionResultsScreen
└── Inspection Results Button ← NEW
    └── InspectionResultsScreen
        └── New Inspection / View Details
```

## Routes Configuration

Add to your GoRouter:
```dart
GoRoute(
  path: '/crops/manual-check/:fieldId',
  name: 'manual-check',
  builder: (context, state) {
    final fieldId = state.pathParameters['fieldId']!;
    final cropId = state.queryParameters['cropId'] ?? '';
    return ManualCropCheckScreen(
      fieldId: fieldId,
      cropId: cropId,
    );
  },
),
GoRoute(
  path: '/crops/inspection-results/:fieldId',
  name: 'inspection-results',
  builder: (context, state) {
    final fieldId = state.pathParameters['fieldId']!;
    return InspectionResultsScreen(fieldId: fieldId);
  },
),
GoRoute(
  path: '/crops/inspection-details/:inspectionId',
  name: 'inspection-details',
  builder: (context, state) {
    final inspectionId = state.pathParameters['inspectionId']!;
    return InspectionDetailsScreen(inspectionId: inspectionId);
  },
),
```

## Features Enabled by Manual Crop Check

1. **Disease Early Detection**: Farmers can identify diseases before they spread
2. **Preventive Monitoring**: Regular checks help prevent major issues
3. **Data-Driven Decisions**: Visual observations inform advisory system
4. **Yield Optimization**: Early intervention improves crop yields
5. **Cost Reduction**: Timely action reduces crop losses
6. **Knowledge Building**: Farmers learn crop health indicators

## Localization Support

All UI strings support multi-language through `AppLocalizations`:
- English
- Hindi (& other Indian languages)
- Regional support

## Error Handling

### Common Errors
| Error | Cause | Solution |
|-------|-------|----------|
| Field not found | Invalid fieldId | Verify field exists in farm |
| Crop not found | Invalid cropId | Select valid crop |
| Unauthorized | User not authenticated | Login to continue |
| Server error | Backend issue | Retry or contact support |

## Performance Considerations

1. **Image Optimization**: Images automatically compressed before upload
2. **Offline Support**: Form data cached locally (optional)
3. **Batch Operations**: Summary stats computed server-side
4. **Caching**: Latest inspection cached for quick access

## Security

1. **User Validation**: Only farm owners can create inspections
2. **Data Encryption**: HTTPS for all API calls
3. **Soft Deletes**: No data permanently deleted
4. **Audit Trail**: All changes timestamped and logged

## Future Enhancements

1. ML-based disease detection from photos
2. Historical trend analysis
3. Comparison with neighboring farms
4. Integration with weather API for advisory
5. Mobile app offline support
6. Video recording support
7. Audio notes

## Testing

### Unit Tests
- Model serialization/deserialization
- Risk level calculation logic
- Form validation

### Integration Tests
- API endpoint testing
- Database operations
- Provider state management

### E2E Tests
- Complete user flow from inspection to advisory
- Image upload and storage
- Data persistence

## Support & Troubleshooting

For issues:
1. Check internet connection
2. Verify user authentication
3. Clear app cache if needed
4. Report bugs with inspection ID
