# Comprehensive Endpoint Testing Script
$baseUrl = "http://localhost:5000"
$results = @()

function Test-Endpoint {
  param(
    [string]$name,
    [string]$method,
    [string]$url,
    [string]$body = $null
  )
  
  try {
    $params = @{
      Uri = "$baseUrl$url"
      Method = $method
      UseBasicParsing = $true
      ErrorAction = "Stop"
    }
    
    if ($body) {
      $params['Body'] = $body
      $params['ContentType'] = 'application/json'
    }
    
    $response = Invoke-WebRequest @params
    $result = @{
      Name = $name
      Method = $method
      URL = $url
      Status = $response.StatusCode
      Result = "PASS"
    }
    Write-Host "✅ $name : $($response.StatusCode)" -ForegroundColor Green
  } catch {
    $result = @{
      Name = $name
      Method = $method
      URL = $url
      Status = $_.Exception.Response.StatusCode
      Result = "FAIL"
      Error = $_.Exception.Message
    }
    Write-Host "❌ $name : FAIL" -ForegroundColor Red
  }
  
  return $result
}

# Run tests
Write-Host "`n========== ENDPOINT TESTS ==========`n" -ForegroundColor Cyan

$results += Test-Endpoint -name "Health" -method "GET" -url "/health"
$results += Test-Endpoint -name "Soil Crops" -method "GET" -url "/api/v1/soil-health/crops"
$results += Test-Endpoint -name "Cost Crops" -method "GET" -url "/api/v1/cost-calc/crops"
$results += Test-Endpoint -name "Warehouse All" -method "GET" -url "/api/v1/warehouse/all"
$results += Test-Endpoint -name "Schemes All" -method "GET" -url "/api/v1/schemes/all"
$results += Test-Endpoint -name "Schemes Find" -method "POST" -url "/api/v1/schemes/find" -body '{"crop":"tomato","landArea":2.5,"age":35,"state":"Maharashtra"}'
$results += Test-Endpoint -name "Pest All" -method "GET" -url "/api/v1/pest-detection/all"
$results += Test-Endpoint -name "Fertilizer Calc" -method "POST" -url "/api/v1/fertilizer/calculate" -body '{"crop":"Wheat","landArea":1,"soilNutrients":{"N":10,"P":5,"K":15}}'

# Summary
$passed = ($results | Where-Object { $_.Result -eq "PASS" }).Count
$failed = ($results | Where-Object { $_.Result -eq "FAIL" }).Count

Write-Host "`n========== SUMMARY ==========`n" -ForegroundColor Cyan
Write-Host "Passed: $passed"
Write-Host "Failed: $failed"
Write-Host "Total:  $($results.Count)`n"

$results | Format-Table -AutoSize
