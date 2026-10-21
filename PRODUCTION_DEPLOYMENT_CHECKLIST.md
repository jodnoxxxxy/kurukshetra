# Production Deployment Checklist

## Pre-Production Review

- [ ] **Remove OTP from Response**
  - File: `backend/src/services/otp.service.js`
  - Comment out: `otp: otp` (line 64)
  - File: `backend/src/routes/otp.js`
  - Comment out: `otp: result.otp` (line 78)

- [ ] **Configure SMS Service**
  - Current: Logs to console
  - Replace with: Twilio, AWS SNS, or similar
  - File: `backend/src/services/otp.service.js` (line ~60)

- [ ] **Update CORS Origins**
  - File: `backend/src/app.js` (lines 54-58)
  - Remove: `http://localhost:*` entries
  - Add: Production domain, Flutter app domains

- [ ] **Update Database URL**
  - File: `.env`
  - Change: `DATABASE_URL` from SQLite to PostgreSQL
  - Format: `postgresql://user:password@host:port/dbname`

- [ ] **Configure JWT Secret**
  - File: `.env`
  - Verify: `JWT_SECRET` is strong and random
  - Recommended: 32+ characters, alphanumeric + symbols

- [ ] **SSL/HTTPS Setup**
  - Use: nginx/Apache reverse proxy
  - Get: Free SSL from Let's Encrypt
  - Configure: HTTPS redirect from HTTP

- [ ] **Environment Variables**
  - [ ] `NODE_ENV=production`
  - [ ] `LOG_LEVEL=warn` (reduce verbosity)
  - [ ] `RATE_LIMIT_WINDOW_MS=900000` (15 minutes)
  - [ ] `RATE_LIMIT_MAX_REQUESTS=100`

## Database Migration

```bash
# 1. Backup current SQLite database
cp backend/dev.db backend/dev.db.backup

# 2. Migrate to PostgreSQL
# Create new PostgreSQL database
createdb kurukshetra_prod

# 3. Update DATABASE_URL in .env
export DATABASE_URL="postgresql://..."

# 4. Run migrations
npm run db:migrate -- --name production_schema

# 5. Seed production data (if needed)
npm run db:seed
```

## API Security Review

### Endpoints to Protect
- [ ] All `/api/v1/*` endpoints except:
  - ✅ POST `/auth/send-otp`
  - ✅ POST `/auth/verify-otp`
  - ✅ POST `/auth/register`
  - ✅ POST `/auth/login`
  - ✅ GET `/health`

### Rate Limiting
- [ ] Applied globally at `app.use('/api/', limiter)`
- [ ] Current: 100 requests / 15 minutes
- [ ] Recommendation: 1000 requests / hour for registered users

### Password Policy
- Current: Minimum 6 characters
- Recommendation: Increase to 12+ characters with complexity rules
- Update: File `backend/src/routes/auth.js` line 13

## Testing Checklist

- [ ] **Unit Tests**
  - [ ] OTP generation (randomness, length)
  - [ ] OTP expiry validation
  - [ ] Brute force protection
  - [ ] Password hashing
  - [ ] JWT token generation
  - [ ] Token validation

- [ ] **Integration Tests**
  - [ ] Full registration flow
  - [ ] Full login flow
  - [ ] Token refresh flow
  - [ ] Error handling
  - [ ] Database persistence

- [ ] **Load Testing**
  - [ ] 100 concurrent users
  - [ ] 1000 requests per second
  - [ ] Database connection pooling
  - [ ] Memory leak detection

- [ ] **Security Testing**
  - [ ] SQL injection attempts
  - [ ] XSS payload injection
  - [ ] CSRF token validation
  - [ ] Rate limiting effectiveness
  - [ ] Password hashing verification

## Monitoring & Alerting

### Logs to Monitor
```javascript
// Critical alerts for:
logger.error('...') // All errors should trigger alerts
logger.warn('Failed verification attempts') // Brute force attempts
```

### Metrics to Track
- [ ] API response time (target: <100ms)
- [ ] Error rate (target: <0.1%)
- [ ] Token refresh rate (normal: <10/min)
- [ ] OTP generation rate (normal: <50/min)
- [ ] Failed login attempts (alert if >10/min)
- [ ] Database connection pool usage

### Recommended Tools
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Datadog or New Relic for APM
- Sentry for error tracking
- PagerDuty for on-call alerts

## Performance Optimization

### Database
- [ ] Enable connection pooling (Prisma: 9 connections)
- [ ] Create indexes on frequently queried fields
- [ ] Archive old OTP records (older than 30 days)
- [ ] Set up automated backups (daily)

### API
- [ ] Enable gzip compression (`compression` middleware)
- [ ] Implement caching for health checks
- [ ] Use CDN for static assets (if any)
- [ ] Implement API response caching for public data

### Infrastructure
- [ ] Use load balancer (nginx/haproxy)
- [ ] Deploy multiple backend instances
- [ ] Use container orchestration (Docker/Kubernetes)
- [ ] Set up auto-scaling based on CPU/memory

## Backup & Recovery

- [ ] Daily database backups (automated)
- [ ] Weekly full backups (off-site)
- [ ] Monthly test recovery from backup
- [ ] Backup retention: 30 days minimum
- [ ] Document recovery procedure
- [ ] Test recovery procedure monthly

## Compliance & Security

- [ ] GDPR compliance (data deletion)
- [ ] PCI DSS (if handling cards) - N/A for now
- [ ] OWASP Top 10 review completed
- [ ] Penetration testing scheduled
- [ ] Security audit completed
- [ ] Privacy policy updated
- [ ] Terms of service updated

## Deployment Steps

```bash
# 1. Prepare environment
cd kurukshetra/backend
npm ci --production

# 2. Build and test
npm run test
npm run lint

# 3. Database migration
npm run db:migrate -- --deploy

# 4. Start with process manager (PM2)
pm2 start ecosystem.config.js --env production

# 5. Verify health
curl https://api.kurukshetra.com/health

# 6. Monitor logs
pm2 logs kurukshetra-backend
```

## Post-Deployment Verification

- [ ] Health endpoint responding (200 OK)
- [ ] OTP service working (test phone: 9999999999)
- [ ] Registration endpoint working
- [ ] Login endpoint returning tokens
- [ ] Protected endpoints require auth
- [ ] Rate limiting active
- [ ] CORS working from frontend domain
- [ ] SSL certificate valid
- [ ] Database backups running
- [ ] Monitoring/logging active

## Rollback Plan

If issues occur post-deployment:

1. **Immediate Action**
   - Revert to previous version: `git revert <commit>`
   - Or roll back database: `npm run db:migrate:resolve`

2. **Investigation**
   - Check error logs: `pm2 logs`
   - Monitor metrics: Check Datadog/New Relic
   - Review recent changes: `git log --oneline -10`

3. **Communication**
   - Notify users of degraded service
   - Communicate estimated resolution time
   - Post updates on status page

## Post-Launch Monitoring (First 7 Days)

Monitor these metrics closely:

- API error rate (should be <0.1%)
- Response time p95 (should be <200ms)
- Failed login attempts (normal: <1%)
- OTP regeneration rate (normal: <10/min)
- Database query time (should be <50ms)
- Memory usage (should stabilize <500MB)
- CPU usage (should stay <80% under load)

## Long-term Maintenance

- Monthly security updates
- Quarterly dependency updates
- Annual security audit
- Continuous monitoring and optimization
- Regular backup testing
- User feedback incorporation

---

**Last Updated**: April 14, 2026  
**Status**: READY FOR DEPLOYMENT

