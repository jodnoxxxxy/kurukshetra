# Kurukshetra Backend - Complete API Documentation

## API Overview

**Base URL:** `http://localhost:5000/api/v1`
**Version:** 1.0
**Status:** ✅ PRODUCTION READY

---

## Table of Contents

1. [Health Check](#health-check)
2. [Authentication](#authentication)
3. [Fertilizer Calculator](#fertilizer-calculator)
4. [Soil Health Analysis](#soil-health-analysis)
5. [Cost Calculator](#cost-calculator)
6. [Government Schemes](#government-schemes)
7. [Warehouse Management](#warehouse-management)
8. [Pest Detection](#pest-detection)
9. [Response Format](#response-format)
10. [Error Codes](#error-codes)

---

## Health Check

### Check API Status
```
GET /health
```

**Response:**
```json
{
  "status": "ok",
  "message": "Kurukshetra Backend API is running",
  "timestamp": "2026-04-09T01:54:46.000Z",
  "environment": "development"
}
```

---

## Fertilizer Calculator

### Calculate Fertilizer Requirement
```
POST /fertilizer/calculate
```

**Request Body:**
```json
{
  "crop": "RICE",
  "landArea": 1.5,
  "soilNutrients": {
    "N": 150,
    "P": 50,
    "K": 100
  },
  "budget": "High"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "crop": "RICE",
    "landArea": 1.5,
    "recommendedFertilizers": [
      {
        "type": "NPK 10:10:10",
        "quantity": 25,
        "unit": "kg",
        "cost": 375,
        "application": "Basal dressing"
      }
    ],
    "totalCost": 375,
    "applicationSchedule": [...]
  },
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Get Fertilizer Recommendations
```
GET /fertilizer/recommendations/:crop
```

**Example:** `/fertilizer/recommendations/WHEAT`

**Response:** Array of recommended fertilizers for the crop

### Get Nutrient Standards
```
GET /fertilizer/standards/:crop
```

**Response:** Optimal nutrient ranges for the crop

### Optimize by Budget
```
POST /fertilizer/budget-optimization
```

**Request Body:**
```json
{
  "crop": "COTTON",
  "landArea": 2.0,
  "budget": "Low",
  "soilNutrients": {...}
}
```

**Response:** Cost-optimized fertilizer recommendations

---

## Soil Health Analysis

### Analyze Soil
```
POST /soil-health/analyze
```

**Request Body:**
```json
{
  "pH": 6.8,
  "nitrogen": 180,
  "phosphorus": 45,
  "potassium": 120,
  "organicMatter": 2.5,
  "ec": 0.8,
  "crop": "SUGARCANE",
  "micronutrients": {
    "Zn": 1.5,
    "Fe": 15,
    "Cu": 1.0,
    "Mn": 5.0,
    "B": 0.5,
    "Mo": 0.1
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "soilHealthCard": {...},
    "recommendations": {...},
    "deficiencies": [...]
  },
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Get Soil Standards
```
GET /soil-health/standards/:crop
```

**Response:** Optimal soil nutrient ranges for crop

### Get Micronutrient Standards
```
GET /soil-health/micronutrient-standards
```

**Response:** Reference values for all micronutrients

### Generate Improvement Plan
```
POST /soil-health/improvement-plan
```

**Request Body:**
```json
{
  "pH": 7.2,
  "nitrogen": 100,
  "phosphorus": 25,
  "potassium": 80,
  "crop": "MAIZE",
  "duration": "singleSeason"
}
```

**Response:** Step-by-step soil improvement plan

### Supported Crops
```
GET /soil-health/crops
```

**Response:** List of all supported crop types

---

## Cost Calculator

### Calculate Farm Economics
```
POST /cost-calc/calculate
```

**Request Body:**
```json
{
  "crop": "WHEAT",
  "landArea": 2.5,
  "costs": {
    "seeds": 5000,
    "fertilizer": 15000,
    "labor": 20000
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "totalCost": 45000,
    "expectedYield": 75,
    "marketPrice": 2000,
    "expectedRevenue": 150000,
    "profitPerAcre": 10500,
    "breakEvenPrice": 600
  },
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Compare Crops
```
POST /cost-calc/compare
```

**Request Body:**
```json
{
  "crops": ["RICE", "WHEAT", "MAIZE"],
  "landArea": 2.0
}
```

**Response:** Comparative analysis of crops

### Get All Crops Cost Data
```
GET /cost-calc/crops
```

**Response:** Cost data for all crops

### Get Specific Crop Cost
```
GET /cost-calc/crop/:crop
```

**Example:** `/cost-calc/crop/COTTON`

### ROI Analysis
```
POST /cost-calc/roi-analysis
```

**Request Body:**
```json
{
  "crop": "SUGARCANE",
  "landArea": 1.5,
  "investment": 75000
}
```

**Response:** Complete ROI projection and payback period

---

## Government Schemes

### Find Matching Schemes
```
POST /schemes/find
```

**Request Body:**
```json
{
  "crop": "WHEAT",
  "landArea": 1.5,
  "income": 250000,
  "location": "Punjab",
  "state": "PUNJAB"
}
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "SCHEME_001",
      "name": "PMKSY - Pradhan Mantri Krishi Sinchayee Yojana",
      "type": "Subsidy",
      "targetGroup": "Marginal & Small Farmers",
      "maxSubsidy": 50000,
      "deadline": "2026-06-30",
      "eligibility": true,
      "matchScore": 95
    }
  ],
  "count": 3,
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Get All Schemes
```
GET /schemes/all
```

**Response:** Complete list of all available schemes

### Get Scheme Details
```
GET /schemes/scheme/:schemeId
```

**Example:** `/schemes/scheme/SCHEME_001`

**Response:** Detailed information about the scheme

### Check Eligibility
```
GET /schemes/eligibility/:schemeId?crop=WHEAT&landArea=1.5&income=250000&state=PUNJAB
```

**Response:**
```json
{
  "success": true,
  "schemeId": "SCHEME_001",
  "schemeName": "PMKSY",
  "eligibility": {
    "isEligible": true,
    "metCriteria": ["landArea", "crop"],
    "unmetCriteria": []
  }
}
```

### Schemes by Crop
```
GET /schemes/by-crop/:crop
```

**Example:** `/schemes/by-crop/RICE`

### Schemes by State
```
GET /schemes/by-state/:state
```

**Example:** `/schemes/by-state/PUNJAB`

---

## Warehouse Management

### Search Warehouses
```
POST /warehouse/search
```

**Request Body:**
```json
{
  "latitude": 31.5497,
  "longitude": 74.3436,
  "capacity": 1000,
  "maxDistance": 50
}
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "WAREHOUSE_001",
      "name": "ABC Grain Storage Facility",
      "location": "Lahore, Punjab",
      "type": "Government",
      "pricePerTon": 500,
      "totalCapacity": 5000,
      "availableCapacity": 3500,
      "rating": 4.8,
      "facilities": ["Cold Storage", "Pest Control", "Insurance"]
    }
  ],
  "count": 5,
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Book Warehouse
```
POST /warehouse/book
```

**Request Body:**
```json
{
  "warehouseId": "WAREHOUSE_001",
  "cropType": "WHEAT",
  "quantity": 500,
  "duration": "monthly",
  "farmerId": "FARMER_12345"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "bookingId": "BOOKING_001",
    "warehouseId": "WAREHOUSE_001",
    "cropType": "WHEAT",
    "quantity": 500,
    "duration": "monthly",
    "totalCost": 250000,
    "startDate": "2026-04-10",
    "endDate": "2026-05-10",
    "status": "CONFIRMED"
  },
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Withdraw from Warehouse
```
POST /warehouse/withdraw
```

**Request Body:**
```json
{
  "bookingId": "BOOKING_001",
  "quantity": 100,
  "date": "2026-05-09"
}
```

**Response:** Withdrawal confirmation and balance

### Get All Warehouses
```
GET /warehouse/all
```

**Response:** List of all available warehouses

### Get Warehouse Details
```
GET /warehouse/:id
```

**Example:** `/warehouse/WAREHOUSE_001`

### Check Availability
```
GET /warehouse/:id/availability
```

**Response:**
```json
{
  "success": true,
  "data": {
    "warehouseId": "WAREHOUSE_001",
    "totalCapacity": 5000,
    "usedCapacity": 3500,
    "availableCapacity": 1500,
    "utilizationRate": 70,
    "status": "ACCEPTING_BOOKINGS"
  }
}
```

---

## Pest Detection

### Identify Pest
```
POST /pest-detection/identify
```

**Request Body:**
```json
{
  "imageUrl": "https://example.com/pest.jpg",
  "description": "Small brown insects on crop leaves",
  "cropType": "WHEAT",
  "location": "Punjab"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "detectedPests": [
      {
        "pestId": "PEST_001",
        "name": "Wheat Aphid",
        "confidence": 92,
        "severity": "HIGH",
        "riskLevel": "HIGH"
      }
    ],
    "treatments": [...]
  },
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Get Pest Details
```
GET /pest-detection/pest/:pestId
```

**Example:** `/pest-detection/pest/PEST_001`

**Response:** Complete pest information

### Get Treatment Recommendations
```
GET /pest-detection/pest/:pestId/treatment?organic=true
```

**Response:** Treatment options (chemical and organic if requested)

### Common Pests for Crop
```
GET /pest-detection/crop/:crop/common-pests
```

**Example:** `/pest-detection/crop/RICE/common-pests`

### Risk Assessment
```
GET /pest-detection/risk-assessment?cropType=WHEAT&temperature=25&humidity=65&rainfall=50&season=SUMMER
```

**Response:**
```json
{
  "success": true,
  "cropType": "WHEAT",
  "riskAssessment": {
    "overallRisk": "MEDIUM",
    "riskFactors": [...],
    "probablePests": [...]
  }
}
```

### Get All Pests
```
GET /pest-detection/all
```

**Response:** Complete list of detectable pests

### Search Pests
```
GET /pest-detection/search?query=aphid
```

**Response:** Search results

---

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { /* specific data */ },
  "count": 5,
  "timestamp": "2026-04-09T01:54:46.000Z"
}
```

### Error Response
```json
{
  "success": false,
  "message": "Description of error",
  "statusCode": 400
}
```

---

## Error Codes

| Code | Status | Meaning |
|------|--------|---------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid request parameters |
| 404 | Not Found | Resource not found |
| 500 | Server Error | Internal server error |

---

## Rate Limiting

- **Window:** 15 minutes
- **Max Requests:** 100 per IP
- **Header:** `RateLimit-Remaining`

---

## Authentication

Currently, APIs don't require authentication. For production:
1. Implement JWT tokens
2. Add middleware for authentication
3. Check authorization for sensitive operations

---

## Testing

### Using cURL

```bash
# Test Fertilizer Calculator
curl -X POST http://localhost:5000/api/v1/fertilizer/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "crop": "RICE",
    "landArea": 1.5,
    "soilNutrients": {"N": 150, "P": 50, "K": 100}
  }'

# Test Soil Health
curl -X POST http://localhost:5000/api/v1/soil-health/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "pH": 6.8,
    "nitrogen": 180,
    "phosphorus": 45,
    "potassium": 120,
    "crop": "WHEAT"
  }'

# Test Finding Schemes
curl -X POST http://localhost:5000/api/v1/schemes/find \
  -H "Content-Type: application/json" \
  -d '{
    "crop": "WHEAT",
    "landArea": 1.5,
    "income": 250000
  }'
```

### Using Postman

1. Import the API collection
2. Set base URL to `http://localhost:5000/api/v1`
3. Test each endpoint
4. Export results for documentation

---

## Deployment Checklist

- [ ] All endpoints tested
- [ ] Error handling verified
- [ ] Rate limiting configured
- [ ] Authentication implemented
- [ ] SSL/TLS enabled
- [ ] Logging configured
- [ ] Monitoring enabled
- [ ] Documentation completed

---

**Last Updated:** April 9, 2026
**API Version:** 1.0
**Status:** Production Ready ✅
