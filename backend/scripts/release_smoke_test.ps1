$ErrorActionPreference = 'Stop'

Write-Host '=== Kurukshetra Release Smoke Test ===' -ForegroundColor Cyan

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw "FAILED: $Message"
    }

    Write-Host "PASS: $Message" -ForegroundColor Green
}

# 1) Health check
$health = Invoke-RestMethod -Uri 'http://localhost:5000/health' -Method Get -TimeoutSec 10
Assert-True ($health.status -eq 'ok') 'Health endpoint returns ok'

# 2) Register unique user
$ts = Get-Date -Format 'yyyyMMddHHmmss'
$email = "smoke_$ts@test.com"
$registerBody = @{
    email = $email
    password = 'Password123!'
    firstName = 'Smoke'
    lastName = 'Test'
    phone = '9876543210'
    role = 'FARMER'
} | ConvertTo-Json

$registerResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/auth/register' -Method Post -ContentType 'application/json' -Body $registerBody
Assert-True ($registerResp.success -eq $true) 'Auth register succeeds'

# 3) Login and retrieve tokens
$loginBody = @{ email = $email; password = 'Password123!' } | ConvertTo-Json
$loginResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/auth/login' -Method Post -ContentType 'application/json' -Body $loginBody
Assert-True ($loginResp.success -eq $true) 'Auth login succeeds'

$accessToken = $loginResp.data.accessToken
$refreshToken = $loginResp.data.refreshToken
Assert-True (-not [string]::IsNullOrWhiteSpace($accessToken)) 'Access token returned'
Assert-True (-not [string]::IsNullOrWhiteSpace($refreshToken)) 'Refresh token returned'

# 4) Access protected endpoint with token
$profileResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/auth/profile' -Method Get -Headers @{ Authorization = "Bearer $accessToken" }
Assert-True ($profileResp.success -eq $true) 'Protected profile endpoint works with token'

# 5) Ensure protected endpoint blocks without token
$blocked = $false
try {
    Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/farms' -Method Get -ErrorAction Stop | Out-Null
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        $blocked = $true
    }
}
Assert-True $blocked 'Protected routes block requests without token (401)'

# 6) Refresh token flow
$refreshBody = @{ refreshToken = $refreshToken } | ConvertTo-Json
$refreshResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/auth/refresh-token' -Method Post -ContentType 'application/json' -Body $refreshBody
Assert-True ($refreshResp.success -eq $true) 'Refresh token endpoint succeeds'
Assert-True (-not [string]::IsNullOrWhiteSpace($refreshResp.data.accessToken)) 'Refresh returns a new access token'

# 7) Spot-check core business endpoints with token
$fertilizerResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/fertilizer/recommendations/wheat' -Method Get -Headers @{ Authorization = "Bearer $accessToken" }
Assert-True ($fertilizerResp.success -eq $true) 'Fertilizer endpoint responds'

$schemeResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/schemes/all' -Method Get -Headers @{ Authorization = "Bearer $accessToken" }
Assert-True ($schemeResp.success -eq $true) 'Schemes endpoint responds'

$warehouseResp = Invoke-RestMethod -Uri 'http://localhost:5000/api/v1/warehouse/all' -Method Get -Headers @{ Authorization = "Bearer $accessToken" }
Assert-True ($warehouseResp.success -eq $true) 'Warehouse endpoint responds'

Write-Host '=== Smoke test completed successfully ===' -ForegroundColor Cyan
exit 0
