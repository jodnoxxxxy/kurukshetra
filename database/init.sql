-- Initialize database with extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- Create indexes for better performance
-- These will be created by Prisma migrations, but keeping for reference
