# 🐘 PostgreSQL Setup Guide for Kurukshetra

## Quick Setup (Windows)

### Option 1: Install PostgreSQL Locally (Recommended for Development)

#### Step 1: Download PostgreSQL

1. Go to: https://www.postgresql.org/download/windows/
2. Download **PostgreSQL 15** or later (choose version 15, 16, or 17)
3. Run the installer (e.g., `postgresql-15-windows-x64.exe`)

#### Step 2: Installation Settings

During installation, remember these settings:

```
Port: 5432 (default)
Superuser: postgres
Password: [Choose a strong password - WRITE THIS DOWN!]
Locale: Default locale
```

**IMPORTANT:** Save your postgres password somewhere safe!

#### Step 3: Verify Installation

Open PowerShell and run:

```powershell
# Check if PostgreSQL service is running
Get-Service -Name postgresql*

# Should show "Running" status
```

#### Step 4: Create Database

Open **pgAdmin 4** (installed with PostgreSQL):

1. Connect to PostgreSQL server using your password
2. Right-click on "Databases" → Create → Database
3. Name: `kurukshetra`
4. Owner: `postgres`
5. Click Save

OR use command line:

```bash
# Open Command Prompt
cd "C:\Program Files\PostgreSQL\15\bin"

# Connect as postgres user
psql -U postgres

# Create database
CREATE DATABASE kurukshetra;

# Verify
\l

# Exit
\q
```

---

### Option 2: Use Cloud Database (Recommended for Production)

#### Neon Technology (FREE Tier) ⭐ RECOMMENDED

1. **Sign Up**
   - Go to https://neon.tech
   - Sign up with GitHub or email
   - Free tier includes: 0.5 GB storage, unlimited databases

2. **Create Project**
   - Click "New Project"
   - Project name: `kurukshetra`
   - Click "Create"

3. **Get Connection String**
   - Go to Dashboard → Your Project
   - Click "Connect"
   - Copy the connection string (looks like):
     ```
     postgresql://username:password@ep-xyz.region.aws.neon.tech/kurukshetra?sslmode=require
     ```

4. **Update .env file**
   ```env
   DATABASE_URL="postgresql://username:password@ep-xyz.region.aws.neon.tech/kurukshetra?sslmode=require"
   ```

#### Supabase (FREE Tier)

1. **Sign Up**
   - Go to https://supabase.com
   - Sign up with GitHub
   - Free tier: 500 MB database

2. **Create Project**
   - Click "New Project"
   - Name: `kurukshetra`
   - Database password: [Save this!]
   - Region: Choose closest to you

3. **Get Connection String**
   - Go to Settings → Database
   - Click "Connection string" tab
   - Copy URI

4. **Update .env file**

---

### Option 3: Docker (Advanced Users)

If you have Docker installed:

```bash
# Pull PostgreSQL image
docker pull postgres:15

# Run container
docker run --name kurukshetra-db \
  -e POSTGRES_PASSWORD=your_password \
  -e POSTGRES_DB=kurukshetra \
  -p 5432:5432 \
  -d postgres:15

# Your DATABASE_URL will be:
DATABASE_URL="postgresql://postgres:your_password@localhost:5432/kurukshetra"
```

---

## Configure Your .env File

After setting up PostgreSQL, update your `.env` file:

```env
# LOCAL DATABASE (if using local PostgreSQL)
DATABASE_URL="postgresql://postgres:YOUR_PASSWORD@localhost:5432/kurukshetra?schema=public"

# OR CLOUD DATABASE (if using Neon/Supabase)
DATABASE_URL="postgresql://username:password@host.region.aws.neon.tech/kurukshetra?sslmode=require"
```

**Replace:**
- `YOUR_PASSWORD` with your actual postgres password
- For cloud DB: replace entire URL with your connection string

---

## Test Database Connection

### Method 1: Using PowerShell

```powershell
# Navigate to backend folder
cd c:\Users\ShreyashDalvi\kurukshetra\backend

# Test connection with Prisma
npx prisma db pull
```

If successful, you'll see:
```
✔ Generated Prisma Client to ./node_modules/@prisma/client
```

### Method 2: Using psql

```bash
# Navigate to PostgreSQL bin directory
cd "C:\Program Files\PostgreSQL\15\bin"

# Connect to kurukshetra database
psql -U postgres -d kurukshetra

# If connected successfully, you'll see:
kurukshetra=#

# Exit
\q
```

---

## Common Issues & Solutions

### Issue 1: "Cannot connect to database"

**Solutions:**
1. Check if PostgreSQL service is running:
   ```powershell
   Get-Service postgresql-x64-15
   ```

2. Verify port 5432 is not blocked:
   ```powershell
   netstat -ano | findstr :5432
   ```

3. Check DATABASE_URL in `.env` file
4. Ensure password is correct

### Issue 2: "Authentication failed"

**Solutions:**
1. Reset postgres password:
   ```sql
   ALTER USER postgres WITH PASSWORD 'new_password';
   ```

2. Update `.env` with new password

### Issue 3: "Database does not exist"

**Solution:**
```sql
-- Connect to PostgreSQL
psql -U postgres

-- Create database
CREATE DATABASE kurukshetra;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE kurukshetra TO postgres;
```

### Issue 4: Port already in use

**Solution:**
```powershell
# Find process using port 5432
netstat -ano | findstr :5432

# Stop conflicting service or change port in .env
PORT=5433
```

---

## Next Steps After Database Setup

1. ✅ Set up PostgreSQL database
2. ✅ Update `.env` file with DATABASE_URL
3. ⏭️ Run Prisma migrations:
   ```bash
   npx prisma migrate dev --name init
   ```

4. ⏭️ Seed test data (optional):
   ```bash
   npx prisma db seed
   ```

5. ⏭️ Start backend server:
   ```bash
   npm run dev
   ```

---

## Quick Reference

### Local PostgreSQL Commands

```bash
# Start PostgreSQL service (Windows)
net start postgresql-x64-15

# Stop PostgreSQL service
net stop postgresql-x64-15

# Connect to database
psql -U postgres -d kurukshetra

# List all databases
\l

# List all tables
\dt

# Describe table structure
\d table_name

# Exit
\q
```

### Environment Variables

```env
# Local Development
DATABASE_URL="postgresql://postgres:password@localhost:5432/kurukshetra"

# Cloud (Neon)
DATABASE_URL="postgresql://user:pass@host.region.aws.neon.tech/db?sslmode=require"

# Docker
DATABASE_URL="postgresql://postgres:password@localhost:5432/kurukshetra"
```

---

## Recommended Tools

### Database Management GUIs

1. **pgAdmin 4** (comes with PostgreSQL)
   - Full-featured
   - Free and open-source

2. **DBeaver Community**
   - Download: https://dbeaver.io
   - Supports multiple databases
   - Free version available

3. **TablePlus**
   - Modern UI
   - Free tier available
   - Paid for full features

### VS Code Extensions

1. **Prisma** - Official extension
2. **SQLTools** - Database query tool
3. **SQLTools PostgreSQL** - PostgreSQL driver

---

## Database Schema Overview

Your Kurukshetra database includes:

- **farmers** - User accounts
- **farms** - Farm locations and details
- **crops** - Crop planting and harvesting
- **market_prices** - Agricultural market data
- **chat_messages** - AI chat history
- **soil_analyses** - Soil test results
- **pest_detections** - Pest identification records

Total: 7 tables with relationships and indexes optimized for farming analytics.

---

## Need Help?

- **Prisma Docs:** https://www.prisma.io/docs
- **PostgreSQL Docs:** https://www.postgresql.org/docs/
- **Neon Docs:** https://neon.tech/docs

---

**Setup Time:** ~15 minutes  
**Difficulty:** Beginner-friendly  
**Next:** Run `npx prisma migrate dev --name init` after database is ready! 🚀
