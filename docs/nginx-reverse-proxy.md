# Nginx Reverse Proxy Routing

## Overview

This feature adds nginx reverse proxy routing to openclaw-webtop, providing clean path-based access to all services through a single entry point.

## Motivation

Previously, users had to access services via multiple ports:
- Webtop: `http://localhost:3000/`
- ModelRelay: `http://localhost:7352/`
- OmniRoute: `http://localhost:20128/`
- OpenClaw: `http://localhost:18789/`

This was inconvenient, especially in GitHub Codespaces where each port needs separate forwarding.

## Solution

Nginx reverse proxy on port 8080 routes requests based on URL path:
- `/` → Webtop Desktop (port 3000)
- `/modelrelay/` → ModelRelay Admin UI (port 7352)
- `/omniroute/` → OmniRoute Dashboard (port 20128)
- `/openclaw/` → OpenClaw Dashboard (port 18789)

## Architecture

```
User Request
    ↓
Port 8080 (Nginx)
    ↓
Path-based routing
    ↓
┌─────────────┬──────────────┬──────────────┬──────────────┐
│      /      │  /modelrelay │  /omniroute  │  /openclaw   │
│             │              │              │              │
│  Port 3000  │  Port 7352   │  Port 20128  │  Port 18789  │
│  (Webtop)   │ (ModelRelay) │ (OmniRoute)  │ (OpenClaw)   │
└─────────────┴──────────────┴──────────────┴──────────────┘
```

## Implementation Details

### Files Added

1. **`docker/nginx.conf`**
   - Main nginx configuration
   - Listens on port 8080
   - Proxy pass to internal services
   - WebSocket support with 24-hour timeouts
   - Health check endpoint at `/health`

2. **`docker/start-nginx.sh`**
   - Startup script executed during container initialization
   - Launches nginx in background

### Files Modified

1. **`docker/Dockerfile`**
   - Install nginx package
   - Copy nginx.conf to `/etc/nginx/sites-available/default`
   - Set up nginx startup script
   - Expose port 8080

2. **`docker-compose.yml`**
   - Add port mapping `8080:8080` for nginx
   - Add port mapping `7352:7352` for ModelRelay direct access
   - Update port comments for clarity

## Usage

### Recommended: Via Nginx (Port 8080)

Access all services through clean URLs:

```bash
# Webtop Desktop
http://localhost:8080/

# ModelRelay Admin UI
http://localhost:8080/modelrelay/

# OmniRoute Dashboard
http://localhost:8080/omniroute/

# OpenClaw Dashboard
http://localhost:8080/openclaw/
```

### Alternative: Direct Port Access

Direct port access is still available for debugging or advanced use:

```bash
http://localhost:3000/   # Webtop
http://localhost:7352/   # ModelRelay
http://localhost:20128/  # OmniRoute
http://localhost:18789/  # OpenClaw
```

## GitHub Codespaces

In Codespaces, only forward port **8080**:

1. Start container: `make start`
2. Go to **Ports** tab
3. Forward port **8080**
4. Click the forwarded URL
5. Access all services via paths

## Benefits

✅ **Single entry point** - Only one port to forward  
✅ **Clean URLs** - No port numbers in paths  
✅ **WebSocket support** - All services work properly  
✅ **Backward compatible** - Direct port access still works  
✅ **Production ready** - Same setup for dev and prod  
✅ **GitHub Codespaces friendly** - Simplified port forwarding  

## Testing

### Health Check

```bash
curl http://localhost:8080/health
# Expected: OK
```

### Service Availability

```bash
# Test Webtop
curl -I http://localhost:8080/

# Test ModelRelay
curl -I http://localhost:8080/modelrelay/

# Test OmniRoute
curl -I http://localhost:8080/omniroute/

# Test OpenClaw
curl -I http://localhost:8080/openclaw/
```

### Nginx Logs

```bash
# View nginx logs
docker exec openclaw-webtop cat /var/log/nginx/access.log
docker exec openclaw-webtop cat /var/log/nginx/error.log
```

## Troubleshooting

### Nginx not starting

**Check if nginx is running:**
```bash
docker exec openclaw-webtop ps aux | grep nginx
```

**Check nginx configuration:**
```bash
docker exec openclaw-webtop nginx -t
```

**View startup logs:**
```bash
docker logs openclaw-webtop | grep nginx
```

### Service not accessible via path

1. **Verify service is running on its port:**
   ```bash
   docker exec openclaw-webtop curl -I http://localhost:7352/
   ```

2. **Check nginx config:**
   ```bash
   docker exec openclaw-webtop cat /etc/nginx/sites-available/default
   ```

3. **Test direct port access first** to isolate the issue

### WebSocket connection issues

- Ensure you're using HTTP (not HTTPS) for local testing
- Check browser console for WebSocket errors
- Verify nginx WebSocket headers are present

## Configuration

### Nginx Configuration

The nginx configuration is located at `docker/nginx.conf`. Key settings:

```nginx
# WebSocket support
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";

# Long timeouts for persistent connections
proxy_read_timeout 86400;
proxy_send_timeout 86400;

# Large buffers for web apps
proxy_buffer_size 128k;
proxy_buffers 4 256k;
proxy_busy_buffers_size 256k;
```

### Customization

To add more services or modify paths, edit `docker/nginx.conf`:

```nginx
location /myservice/ {
    proxy_pass http://127.0.0.1:<port>/;
    # ... proxy headers ...
}
```

Then rebuild the image:
```bash
make build-local
```

## Known Limitations

1. **OmniRoute dashboard port** - Currently assumes port 20128 (needs verification)
2. **Subfolder support** - ModelRelay/OmniRoute may need configuration for subfolder paths
3. **SSL/TLS** - No SSL termination in nginx (uses Webtop's built-in HTTPS on port 3001)
4. **Authentication** - No auth layer (relies on GitHub Codespaces auth or external proxy)

## Future Improvements

- [ ] Verify OmniRoute dashboard port
- [ ] Test and document subfolder configuration for ModelRelay/OmniRoute
- [ ] Add optional SSL/TLS termination
- [ ] Add optional authentication layer (basic auth, OAuth)
- [ ] Performance tuning for production use
- [ ] Add nginx metrics/monitoring endpoint

## Related Documentation

- [NGINX_ROUTING.md](../NGINX_ROUTING.md) - User-facing documentation
- [IMPLEMENTATION_SUMMARY.md](../IMPLEMENTATION_SUMMARY.md) - Technical implementation details

## References

- [Nginx Reverse Proxy Documentation](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [Nginx WebSocket Proxying](https://nginx.org/en/docs/http/websocket.html)
- [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop/)

---

**Created**: 2026-04-29  
**Author**: ShuaiGE  
**Branch**: `feature/nginx-routing`  
**Status**: Ready for testing
