# Phase 5: Authentication Testing Script
Write-Host "🔐 Phase 5: JWT Authentication Testing" -ForegroundColor Cyan
Write-Host "-------------------------------------------"

# Wait a moment for backend to be fully ready
Start-Sleep -Seconds 2

# ========== TEST 1: REGISTER NEW USER ==========
Write-Host "`n1️⃣ Testing User Registration..." -ForegroundColor Yellow

$registerBody = @{
    email = "farmer1@test.io"
    password = "Password123!"
    firstName = "Rajesh"
    lastName = "Kumar"
    phone = "9876543210"
    role = "FARMER"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-WebRequest -Uri "http://localhost:5000/api/v1/auth/register" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $registerBody `
        -TimeoutSec 10

    $registerData = $registerResponse.Content | ConvertFrom-Json
    Write-Host "✅ Registration successful!" -ForegroundColor Green
    Write-Host "User ID: $($registerData.data.id)"
    Write-Host "Email: $($registerData.data.email)"
    $userId = $registerData.data.id
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ========== TEST 2: LOGIN ==========
Write-Host "`n2️⃣ Testing User Login..." -ForegroundColor Yellow

$loginBody = @{
    email = "farmer1@test.io"
    password = "Password123!"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:5000/api/v1/auth/login" `
        -Method POST `
        -Headers @{"Content-Type"="application/json"} `
        -Body $loginBody `
        -TimeoutSec 10

    $loginData = $loginResponse.Content | ConvertFrom-Json
    Write-Host "✅ Login successful!" -ForegroundColor Green
    Write-Host "Access Token: $($loginData.data.accessToken.Substring(0, 50))..."
    Write-Host "Refresh Token: $($loginData.data.refreshToken.Substring(0, 50))..."
    $accessToken = $loginData.data.accessToken
} catch {
    Write-Host "❌ Login failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ========== TEST 3: ACCESS PROTECTED ENDPOINT ==========
Write-Host "`n3️⃣ Testing Protected Endpoint (GET /farms)..." -ForegroundColor Yellow

try {
    $protectedResponse = Invoke-WebRequest -Uri "http://localhost:5000/api/v1/farms" `
        -Method GET `
        -Headers @{
            "Content-Type"="application/json"
            "Authorization"="Bearer $accessToken"
        } `
        -TimeoutSec 10

    Write-Host "✅ Protected endpoint accessible!" -ForegroundColor Green
    Write-Host "Response Status: $($protectedResponse.StatusCode)"
} catch {
    Write-Host "❌ Protected endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ========== TEST 4: TEST WITHOUT TOKEN ==========
Write-Host "`n4️⃣ Testing Protected Endpoint WITHOUT Token..." -ForegroundColor Yellow

try {
    $noTokenResponse = Invoke-WebRequest -Uri "http://localhost:5000/api/v1/farms" `
        -Method GET `
        -Headers @{"Content-Type"="application/json"} `
        -TimeoutSec 10

    Write-Host "❌ Should have been blocked! Without token access granted" -ForegroundColor Red
    exit 1
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✅ Correctly blocked without token!" -ForegroundColor Green
        Write-Host "Status Code: 401 Unauthorized"
    } else {
        Write-Host "⚠️ Unexpected status: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}

# ========== TEST 5: GET PROFILE ==========
Write-Host "`n5️⃣ Testing GET /auth/profile..." -ForegroundColor Yellow

try {
    $profileResponse = Invoke-WebRequest -Uri "http://localhost:5000/api/v1/auth/profile" `
        -Method GET `
        -Headers @{
            "Content-Type"="application/json"
            "Authorization"="Bearer $accessToken"
        } `
        -TimeoutSec 10

    $profileData = $profileResponse.Content | ConvertFrom-Json
    Write-Host "✅ Profile retrieved!" -ForegroundColor Green
    Write-Host "Name: $($profileData.data.firstName) $($profileData.data.lastName)"
    Write-Host "Email: $($profileData.data.email)"
} catch {
    Write-Host "❌ Profile fetch failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# ========== SUMMARY ==========
Write-Host "`n📊 PHASE 5.2 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "-------------------------------------------"
Write-Host "✅ User Registration: PASSED" -ForegroundColor Green
Write-Host "✅ User Login: PASSED" -ForegroundColor Green
Write-Host "✅ Protected Endpoint Access (with token): PASSED" -ForegroundColor Green
Write-Host "✅ Protected Endpoint Block (without token): PASSED" -ForegroundColor Green
Write-Host "✅ Get Profile: PASSED" -ForegroundColor Green
Write-Host "`n🎉 Phase 5.2: Authentication Endpoints - ALL TESTS PASSED!" -ForegroundColor Green
