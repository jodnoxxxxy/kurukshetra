$testPayload = @{
    name = "Raj Sharma"
    email = "raj@farmer.local"
    phone = "9876543211"
    password = "SecurePass123"
    district = "Pune"
    taluka = "Baramati"
    village = "Bhilar"
    location = "Pune, Baramati, Bhilar"
    state = "Pune"
} | ConvertTo-Json

Write-Host "Testing Registration Endpoint..." -ForegroundColor Cyan
Write-Host "Payload:" -ForegroundColor Yellow
Write-Host $testPayload

$headers = @{
    'Content-Type' = 'application/json'
}

$body = $testPayload

Write-Host "`nSending POST to http://localhost:5000/api/v1/auth/register..." -ForegroundColor Cyan

$request = [System.Net.HttpWebRequest]::Create("http://localhost:5000/api/v1/auth/register")
$request.Method = "POST"
$request.ContentType = "application/json"

$utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
$request.ContentLength = $utf8Bytes.Length
$requestStream = $request.GetRequestStream()
$requestStream.Write($utf8Bytes, 0, $utf8Bytes.Length)
$requestStream.Close()

try {
    $response = $request.GetResponse()
    Write-Host "`n✅ Success!" -ForegroundColor Green
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Yellow
    
    $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
    $responseBody = $reader.ReadToEnd()
    Write-Host "Response:" -ForegroundColor Yellow
    $responseBody | ConvertFrom-Json | ConvertTo-Json | Write-Host
} catch [System.Net.WebException] {
    Write-Host "`n❌ Error!" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    
    $errorStream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorStream)
    $errorBody = $reader.ReadToEnd()
    Write-Host "Error Response:" -ForegroundColor Red
    Write-Host $errorBody -ForegroundColor Red
}
