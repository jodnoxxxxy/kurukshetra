# Test Registration Endpoint
$testPayload = @{
    name = "Test Farmer"
    email = "9876543210@farmer.local"
    phone = "9876543210"
    password = "Password123"
    district = "Pune"
    taluka = "Pune"
    village = "Test Village"
    location = "Pune, Pune, Test Village"
    state = "Pune"
} | ConvertTo-Json

Write-Host "Testing Registration Endpoint..." -ForegroundColor Cyan
Write-Host "Payload:" -ForegroundColor Yellow
Write-Host $testPayload

try {
    $response = Invoke-WebRequest `
        -Uri "http://localhost:5000/api/v1/auth/register" `
        -Method POST `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $testPayload `
        -UseBasicParsing `
        -ErrorAction Stop
    
    Write-Host "`n✅ Registration Successful!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Yellow
    Write-Host "Response:" -ForegroundColor Yellow
    $response.Content | ConvertFrom-Json | ConvertTo-Json | Write-Host
} catch {
    Write-Host "`n❌ Registration Failed!" -ForegroundColor Red
    Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    try {
        $errorResponse = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($errorResponse)
        $body = $reader.ReadToEnd()
        Write-Host "Response Body:" -ForegroundColor Red
        Write-Host $body -ForegroundColor Red
    } catch {
        Write-Host "Could not read error response" -ForegroundColor Gray
    }
}

