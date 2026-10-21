  u# API Testing Plan - Phase 2

## Overview
This document outlines the comprehensive testing strategy for all 35+ API endpoints across 6 controller modules.

---

## Pre-Testing Checklist

- [ ] Backend server is running on port 5000
- [ ] All 6 refactored route files are loaded
- [ ] Postman is installed and collection is imported
- [ ] Request environment variables are set (base_url: http://localhost:5000/api/v1)
- [ ] Database is accessible (SQLite or configured DB)

---

## Testing Phases

### Phase 1: Validation Testing
Test that all endpoints are accessible and return proper responses.

### Phase 2: Functional Testing
Test that each endpoint performs its intended function correctly.

### Phase 3: Error Handling Testing
Test that error cases are handled properly with correct status codes.

### Phase 4: Integration Testing
Test that endpoints work together as expected.

---

## 1. Fertilizer Controller Tests

### Test 1.1: Calculate Fertilizer Requirement
```
Endpoint: POST /fertilizer/calculate
Priority: CRITICAL
```

**Test Case 1.1.1: Valid Request**
```javascript
Request: {
  "crop": "RICE",
  "landArea": 1.5,
  "soilNutrients": {"N": 150, "P": 50, "K": 100},
  "budget": "High"
}

Expected Response:
- Status: 200
- success: true
- data.crop: "RICE"
- data.recommendedFertilizers: Array
```

**Test Case 1.1.2: Invalid Crop**
```javascript
Request: {
  "crop": "INVALID_CROP",
  "landArea": 1.5,
  "soilNutrients": {...}
}

Expected Response:
- Status: 400
- success: false
- message: Contains "Invalid crop"
```

**Test Case 1.1.3: Invalid Land Area**
```javascript
Request: {
  "crop": "RICE",
  "landArea": -1,
  "soilNutrients": {...}
}

Expected Response:
- Status: 400
- success: false
- message: Contains "Land area must be between"
```

### Test 1.2: Get Fertilizer Recommendations
```
Endpoint: GET /fertilizer/recommendations/:crop
Priority: HIGH
```

**Test Cases:**
- [ ] Valid crop (e.g., WHEAT) - Should return 200 with recommendations
- [ ] Invalid crop (e.g., UNKNOWN) - Should return 404
- [ ] All supported crops - Should return data for each

### Test 1.3: Get Nutrient Standards
```
Endpoint: GET /fertilizer/standards/:crop
Priority: HIGH
```

**Test Cases:**
- [ ] Valid crop (e.g., MAIZE) - Should return 200 with standards
- [ ] Check nutrient ranges are reasonable
- [ ] Verify all required fields present

### Test 1.4: Optimize by Budget
```
Endpoint: POST /fertilizer/budget-optimization
Priority: HIGH
```

**Test Cases:**
- [ ] Budget "High" - Should recommend premium fertilizers
- [ ] Budget "Low" - Should recommend economical options
- [ ] Budget "Medium" - Should balance cost and quality

---

## 2. Soil Health Controller Tests

### Test 2.1: Analyze Soil
```
Endpoint: POST /soil-health/analyze
Priority: CRITICAL
```

**Test Case 2.1.1: Valid Soil Data**
```javascript
Request: {
  "pH": 6.8,
  "nitrogen": 180,
  "phosphorus": 45,
  "potassium": 120,
  "organicMatter": 2.5,
  "ec": 0.8,
  "crop": "WHEAT",
  "micronutrients": {...}
}

Expected:
- Status: 200
- data.soilHealthCard exists
- data.recommendations exists
- data.deficiencies is an array
```

**Test Case 2.1.2: Invalid pH**
```javascript
Request: {
  "pH": 15,  // Invalid (should be 0-14)
  ...
}

Expected:
- Status: 400
- success: false
```

### Test 2.2: Get Soil Standards
```
Endpoint: GET /soil-health/standards/:crop
Priority: HIGH
```

**Test Cases:**
- [ ] RICE - Should return specific standards
- [ ] WHEAT - Should return specific standards
- [ ] All crops - Should have consistent structure

### Test 2.3: Get Micronutrient Standards
```
Endpoint: GET /soil-health/micronutrient-standards
Priority: MEDIUM
```

**Test Cases:**
- [ ] Should return all micronutrients (Zn, Fe, Cu, Mn, B, Mo)
- [ ] Should have min/max ranges for each

### Test 2.4: Generate Improvement Plan
```
Endpoint: POST /soil-health/improvement-plan
Priority: HIGH
```

**Test Cases:**
- [ ] Single season plan - Should suggest immediate actions
- [ ] Multi-season plan - Should have phased approach
- [ ] Verify plan addresses detected deficiencies

### Test 2.5: Supported Crops
```
Endpoint: GET /soil-health/crops
Priority: LOW
```

**Test Cases:**
- [ ] Should return array of crops
- [ ] Should have 40+ crops
- [ ] All crop names should be valid

---

## 3. Cost Calculator Controller Tests

### Test 3.1: Calculate Farm Economics
```
Endpoint: POST /cost-calc/calculate
Priority: CRITICAL
```

**Test Case 3.1.1: Complete Cost Data**
```javascript
Request: {
  "crop": "WHEAT",
  "landArea": 2.5,
  "costs": {
    "seeds": 5000,
    "fertilizer": 15000,
    "labor": 20000
  }
}

Expected:
- Status: 200
- data.totalCost: 40000
- data.expectedRevenue > 0
- data.profitPerAcre: number
```

**Test Case 3.1.2: Minimal Input**
```javascript
Request: {
  "crop": "RICE",
  "landArea": 1.0
}

Expected:
- Status: 200
- Should use default cost values
```

### Test 3.2: Compare Crops
```
Endpoint: POST /cost-calc/compare
Priority: HIGH
```

**Test Case 3.2.1: Three Crops Comparison**
```javascript
Request: {
  "crops": ["RICE", "WHEAT", "MAIZE"],
  "landArea": 2.0
}

Expected:
- Status: 200
- data should have 3 crop comparisons
- Should show profit for each
```

### Test 3.3: Get All Crops Cost Data
```
Endpoint: GET /cost-calc/crops
Priority: MEDIUM
```

**Test Cases:**
- [ ] Should return object with all crops
- [ ] Each crop should have costPerAcre, yield, price

### Test 3.4: Get Specific Crop Cost
```
Endpoint: GET /cost-calc/crop/:crop
Priority: MEDIUM
```

**Test Cases:**
- [ ] COTTON - Should return cost data
- [ ] SUGARCANE - Should return cost data
- [ ] Invalid crop - Should return 404

### Test 3.5: ROI Analysis
```
Endpoint: POST /cost-calc/roi-analysis
Priority: HIGH
```

**Test Case 3.5.1: Valid ROI Calculation**
```javascript
Request: {
  "crop": "SUGARCANE",
  "landArea": 1.5,
  "investment": 75000
}

Expected:
- Status: 200
- data.roi: percentage
- data.paybackPeriod: months
- data.projections: array
```

---

## 4. Government Schemes Controller Tests

### Test 4.1: Find Matching Schemes
```
Endpoint: POST /schemes/find
Priority: CRITICAL
```

**Test Case 4.1.1: Farmer Profile**
```javascript
Request: {
  "crop": "WHEAT",
  "landArea": 1.5,
  "income": 250000,
  "location": "Punjab",
  "state": "PUNJAB"
}

Expected:
- Status: 200
- data: array of matching schemes
- Each scheme has eligibility: boolean
- matchScore: number (0-100)
```

**Test Case 4.1.2: Minimal Query**
```javascript
Request: {
  "crop": "RICE"
}

Expected:
- Status: 200
- Should return schemes applicable to RICE
```

### Test 4.2: Get All Schemes
```
Endpoint: GET /schemes/all
Priority: HIGH
```

**Test Cases:**
- [ ] Should return 50+ schemes
- [ ] Each scheme has id, name, benefits
- [ ] All required fields present

### Test 4.3: Get Scheme Details
```
Endpoint: GET /schemes/scheme/:schemeId
Priority: HIGH
```

**Test Cases:**
- [ ] Valid scheme ID - Should return full details
- [ ] Invalid scheme ID - Should return 404
- [ ] Response includes: name, benefits, deadline, portal

### Test 4.4: Check Eligibility
```
Endpoint: GET /schemes/eligibility/:schemeId
Priority: HIGH
```

**Test Cases:**
- [ ] Eligible farmer - isEligible: true
- [ ] Ineligible farmer - isEligible: false
- [ ] Should list met and unmet criteria

### Test 4.5: Schemes by Crop
```
Endpoint: GET /schemes/by-crop/:crop
Priority: MEDIUM
```

**Test Cases:**
- [ ] RICE - Should return rice-specific schemes
- [ ] WHEAT - Should return wheat-specific schemes
- [ ] Unknown crop - Should handle gracefully

### Test 4.6: Schemes by State
```
Endpoint: GET /schemes/by-state/:state
Priority: MEDIUM
```

**Test Cases:**
- [ ] PUNJAB - Should return state schemes
- [ ] MAHARASHTRA - Should return state schemes
- [ ] All states should have at least one scheme

---

## 5. Warehouse Management Controller Tests

### Test 5.1: Search Warehouses
```
Endpoint: POST /warehouse/search
Priority: CRITICAL
```

**Test Case 5.1.1: Location-Based Search**
```javascript
Request: {
  "latitude": 31.5497,
  "longitude": 74.3436,
  "capacity": 1000,
  "maxDistance": 50
}

Expected:
- Status: 200
- data: array of warehouses
- Each warehouse within maxDistance
- availableCapacity >= requested capacity
```

### Test 5.2: Book Warehouse
```
Endpoint: POST /warehouse/book
Priority: CRITICAL
```

**Test Case 5.2.1: Valid Booking**
```javascript
Request: {
  "warehouseId": "WAREHOUSE_001",
  "cropType": "WHEAT",
  "quantity": 500,
  "duration": "monthly",
  "farmerId": "FARMER_12345"
}

Expected:
- Status: 200
- data.bookingId: generated ID
- data.status: "CONFIRMED"
- data.totalCost: calculated
```

### Test 5.3: Withdraw from Warehouse
```
Endpoint: POST /warehouse/withdraw
Priority: HIGH
```

**Test Cases:**
- [ ] Valid withdrawal - Should return remaining balance
- [ ] Insufficient quantity - Should return 400
- [ ] Invalid booking - Should return 404

### Test 5.4: Get All Warehouses
```
Endpoint: GET /warehouse/all
Priority: MEDIUM
```

**Test Cases:**
- [ ] Should return all warehouses
- [ ] Each has required fields

### Test 5.5: Get Warehouse Details
```
Endpoint: GET /warehouse/:id
Priority: MEDIUM
```

**Test Cases:**
- [ ] Valid ID - Should return details
- [ ] Invalid ID - Should return 404

### Test 5.6: Check Availability
```
Endpoint: GET /warehouse/:id/availability
Priority: MEDIUM
```

**Test Cases:**
- [ ] Should return capacity info
- [ ] utilization rate should be percentage
- [ ] status should be AVAILABLE or FULL

---

## 6. Pest Detection Controller Tests

### Test 6.1: Identify Pest
```
Endpoint: POST /pest-detection/identify
Priority: CRITICAL
```

**Test Case 6.1.1: Image-Based Identification**
```javascript
Request: {
  "imageUrl": "https://example.com/pest.jpg",
  "cropType": "WHEAT",
  "location": "Punjab"
}

Expected:
- Status: 200
- data.detectedPests: array
- Each pest has confidence score
- Treatments included
```

**Test Case 6.1.2: Description-Based**
```javascript
Request: {
  "description": "Small brown insects",
  "cropType": "RICE"
}

Expected:
- Status: 200
- Should identify pest from description
```

### Test 6.2: Get Pest Details
```
Endpoint: GET /pest-detection/pest/:pestId
Priority: HIGH
```

**Test Cases:**
- [ ] Valid pest ID - Should return details
- [ ] Invalid pest ID - Should return 404
- [ ] Response includes: morphology, lifecycle, damage

### Test 6.3: Get Treatment Recommendations
```
Endpoint: GET /pest-detection/pest/:pestId/treatment
Priority: HIGH
```

**Test Cases:**
- [ ] With organic=true - Should return organic treatments
- [ ] With organic=false/absent - Should return chemical treatments
- [ ] Each treatment has dosage and frequency

### Test 6.4: Common Pests for Crop
```
Endpoint: GET /pest-detection/crop/:crop/common-pests
Priority: MEDIUM
```

**Test Cases:**
- [ ] RICE - Should return rice pests
- [ ] WHEAT - Should return wheat pests
- [ ] All crops should have associated pests

### Test 6.5: Risk Assessment
```
Endpoint: GET /pest-detection/risk-assessment
Priority: HIGH
```

**Test Case 6.5.1: Environmental Risk**
```javascript
Query: ?cropType=WHEAT&temperature=25&humidity=65&rainfall=50&season=SUMMER

Expected:
- Status: 200
- data.overallRisk: "LOW" | "MEDIUM" | "HIGH"
- data.probablePests: array
- data.riskFactors: array
```

### Test 6.6: Get All Pests
```
Endpoint: GET /pest-detection/all
Priority: MEDIUM
```

**Test Cases:**
- [ ] Should return all pests
- [ ] Should have 100+ pests

### Test 6.7: Search Pests
```
Endpoint: GET /pest-detection/search
Priority: MEDIUM
```

**Test Cases:**
- [ ] Query: "aphid" - Should find aphid-related pests
- [ ] Query: "beetle" - Should find beetles
- [ ] Empty query - Should handle gracefully

---

## Cross-Module Integration Tests

### Integration Test 1: Complete Farmer Workflow
1. Analyze soil → get recommendations
2. Calculate fertilizer needs
3. Compare crop options
4. Find matching schemes
5. Find warehouses for storage
6. Assess pest risks

**Expected Outcome:** All endpoints work together seamlessly

### Integration Test 2: Data Consistency
1. Get crop standards from soil module
2. Use in fertilizer calculations
3. Verify consistency across modules

---

## Performance Tests

### Load Testing
- [ ] 100 concurrent requests to each endpoint
- [ ] Response time < 500ms for each
- [ ] No errors or timeouts

### Stress Testing
- [ ] 1000+ concurrent requests
- [ ] Monitor CPU usage
- [ ] Monitor memory usage

---

## Security Tests

- [ ] SQL Injection attempts - Should be blocked
- [ ] XSS payload in requests - Should be sanitized
- [ ] Large payloads - Should be rejected
- [ ] Invalid auth headers - Should return 401 (when auth implemented)

---

## Testing Tools & Resources

### Postman
- Import: `Kurukshetra_API.postman_collection.json`
- Set environment: `base_url = http://localhost:5000/api/v1`
- Run all tests

### cURL
```bash
# Example test
curl -X POST http://localhost:5000/api/v1/fertilizer/calculate \
  -H "Content-Type: application/json" \
  -d '{"crop":"RICE","landArea":1.5}'
```

### Test Results Documentation

Create a file `TEST_RESULTS.md` to document:
- [ ] Test date and time
- [ ] Endpoints passing: X/35
- [ ] Endpoints failing: X
- [ ] Issues found
- [ ] Performance metrics

---

## Sign-Off Criteria

- [ ] 100% of endpoints return responses
- [ ] 95%+ endpoints return correct status codes
- [ ] All error cases handled properly
- [ ] Response format consistent
- [ ] No unhandled exceptions
- [ ] Performance acceptable

---

**Testing Started:** [Date]
**Testing Completed:** [Date]
**Tested By:** [Name]
**Environment:** Development
**Status:** READY FOR TESTING
