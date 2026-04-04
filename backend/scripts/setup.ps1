# Kurukshetra Backend - Quick Start Script
# Run this AFTER installing PostgreSQL

Write-Host "🚀 Kurukshetra Backend Setup" -ForegroundColor Cyan
Write-Host ""

# Check if .env exists
if (-Not (Test-Path ".env")) {
    Write-Host "❌ .env file not found!" -ForegroundColor Red
    Write-Host "Please copy .env.example to .env and configure it first:" -ForegroundColor Yellow
    Write-Host "  copy .env.example .env" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "✅ .env file found" -ForegroundColor Green

# Check DATABASE_URL
$databaseUrl = Get-Content ".env" | Select-String "DATABASE_URL"
if ($databaseUrl -match 'your_password') {
    Write-Host "⚠️  DATABASE_URL still has placeholder values!" -ForegroundColor Yellow
    Write-Host "Please update .env with your actual database credentials" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit 0
    }
} else {
    Write-Host "✅ DATABASE_URL configured" -ForegroundColor Green
}

# Check JWT_SECRET
$jwtSecret = Get-Content ".env" | Select-String "JWT_SECRET"
if ($jwtSecret -match 'your_super_secret') {
    Write-Host "⚠️  JWT_SECRET still has placeholder value!" -ForegroundColor Yellow
    Write-Host "For development, this is okay. Change in production!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📦 Checking Node modules..." -ForegroundColor Cyan

# Check if node_modules exists
if (-Not (Test-Path "node_modules")) {
    Write-Host "❌ node_modules not found! Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install dependencies!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Dependencies installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔧 Generating Prisma Client..." -ForegroundColor Cyan

# Generate Prisma Client
try {
    npx prisma generate
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Prisma Client generated successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Prisma generation had issues, but continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️  Skipping Prisma generation (database might not be set up yet)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 Setup Summary:" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Ensure PostgreSQL is installed and running" -ForegroundColor White
Write-Host "2. Create 'kurukshetra' database in PostgreSQL" -ForegroundColor White
Write-Host "3. Update .env with your DATABASE_URL" -ForegroundColor White
Write-Host "4. Run: npx prisma migrate dev --name init" -ForegroundColor White
Write-Host "5. Run: npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "📚 For detailed PostgreSQL setup, see:" -ForegroundColor Cyan
Write-Host "   POSTGRESQL_SETUP.md" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Ready to start development server?" -ForegroundColor Cyan
$answer = Read-Host "Start now? (y/n)"

if ($answer -eq 'y') {
    Write-Host ""
    Write-Host "Starting development server..." -ForegroundColor Green
    npm run dev
} else {
    Write-Host ""
    Write-Host "You can start the server manually with: npm run dev" -ForegroundColor Cyan
    Write-Host ""
}
