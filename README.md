# Inngest Self-Hosted Deployment Guide

## Quick Start

1. **Copy environment file**:
   ```bash
   cp .env.example .env
   ```

2. **Generate secure keys**:
   ```bash
   # Generate signing key
   openssl rand -hex 32
   
   # Generate event key (any secure random string)
   openssl rand -base64 32
   ```

3. **Configure environment variables** in `.env`:
   - Set `INNGEST_EVENT_KEY` and `INNGEST_SIGNING_KEY`
   - Set `POSTGRES_PASSWORD`
   - Adjust other settings as needed

4. **Start services**:
   ```bash
   docker-compose up -d
   ```

5. **Access Inngest Dashboard**:
   - Open http://localhost:8288
   - The API is available at the same URL

## Coolify Deployment

### Prerequisites
- Coolify instance running
- Domain name configured (optional but recommended)

### Deployment Steps

1. **Import Project**:
   - In Coolify, create a new project
   - Choose "Docker Compose" as deployment method
   - Upload or paste the `docker-compose.yml` content

2. **Configure Environment Variables**:
   ```
   INNGEST_EVENT_KEY=<your-secure-event-key>
   INNGEST_SIGNING_KEY=<your-64-char-hex-key>
   POSTGRES_PASSWORD=<your-secure-password>
   POSTGRES_DB=inngest
   POSTGRES_USER=inngest
   ```

3. **Configure Domains** (Optional):
   - Main service: `inngest.yourdomain.com` → port 8288
   - Connect gateway: `inngest-connect.yourdomain.com` → port 8289

4. **Deploy**:
   - Click "Deploy" in Coolify
   - Monitor logs for successful startup

## Application Configuration

### Node.js Example

Create these environment variables for your Node.js app:

```bash
# For self-hosted Inngest
INNGEST_EVENT_KEY=<same-as-server>
INNGEST_SIGNING_KEY=<same-as-server>
INNGEST_DEV=0
INNGEST_BASE_URL=http://your-inngest-domain:8288

# Start your app
node server.js
```

### Python Example

```python
from inngest import Inngest

inngest = Inngest(
    app_id="my-app",
    event_key="<your-event-key>",
    signing_key="<your-signing-key>",
    base_url="http://your-inngest-domain:8288"
)
```

## Monitoring and Maintenance

### Health Checks
- Main service: `GET http://localhost:8288/health`
- PostgreSQL: `pg_isready -U inngest -d inngest`
- Redis: `redis-cli ping`

### Backup Strategy

#### PostgreSQL Backup
```bash
# Create backup
docker exec inngest-postgres pg_dump -U inngest inngest > backup.sql

# Restore backup
docker exec -i inngest-postgres psql -U inngest inngest < backup.sql
```

#### Volume Backup
```bash
# Backup volumes
docker run --rm -v inngest_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz /data
docker run --rm -v inngest_redis_data:/data -v $(pwd):/backup alpine tar czf /backup/redis-backup.tar.gz /data
```

### Scaling Considerations

1. **Horizontal Scaling**: Currently, Inngest self-hosted runs as a single node
2. **Resource Scaling**: Adjust CPU/memory limits in docker-compose.yml
3. **Database Scaling**: Consider PostgreSQL read replicas for high load
4. **Redis Scaling**: Use Redis Cluster for high availability

### Troubleshooting

#### Common Issues

1. **Connection refused**:
   - Check if services are running: `docker-compose ps`
   - Verify port configurations
   - Check firewall rules

2. **Authentication errors**:
   - Verify INNGEST_EVENT_KEY and INNGEST_SIGNING_KEY match between server and apps
   - Ensure signing key is valid hexadecimal with even character count

3. **Database connection issues**:
   - Check PostgreSQL health: `docker-compose logs postgres`
   - Verify database credentials in environment variables

4. **Performance issues**:
   - Monitor resource usage: `docker stats`
   - Adjust INNGEST_QUEUE_WORKERS and INNGEST_TICK values
   - Consider external Redis/PostgreSQL for better performance

#### Logs
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f inngest
docker-compose logs -f postgres
docker-compose logs -f redis
```

## Security Best Practices

1. **Use strong, unique keys for production**
2. **Enable TLS/SSL with reverse proxy**
3. **Restrict network access with firewall rules**
4. **Regular security updates for Docker images**
5. **Monitor access logs and set up alerting**
6. **Use Docker secrets for sensitive data in production**

## Production Checklist

- [ ] Strong, unique INNGEST_EVENT_KEY and INNGEST_SIGNING_KEY
- [ ] Secure PostgreSQL password
- [ ] SSL/TLS enabled via reverse proxy
- [ ] Firewall rules configured
- [ ] Backup strategy implemented
- [ ] Monitoring and alerting set up
- [ ] Resource limits configured
- [ ] Health checks operational
- [ ] Log rotation configured
- [ ] Regular security updates scheduled