# Nginx Reverse Proxy Routing

This branch adds nginx reverse proxy routing to provide clean path-based access to all services.

## What Changed

### New Files
- `docker/nginx.conf` - Nginx configuration for reverse proxy routing
- `docker/start-nginx.sh` - Startup script for nginx service

### Modified Files
- `docker/Dockerfile` - Added nginx installation and configuration
- `docker-compose.yml` - Added port 8080 for nginx and port 7352 for ModelRelay

## Access Patterns

### Option 1: Nginx Reverse Proxy (Recommended)
Access everything through port **8080** with clean URLs:

- **Webtop Desktop**: `http://localhost:8080/`
- **ModelRelay Admin**: `http://localhost:8080/modelrelay/`
- **OmniRoute Dashboard**: `http://localhost:8080/omniroute/`
- **OpenClaw Dashboard**: `http://localhost:8080/openclaw/`

### Option 2: Direct Port Access (Still Available)
Access services directly via their ports:

- **Webtop**: `http://localhost:3000/` or `https://localhost:3001/`
- **ModelRelay**: `http://localhost:7352/`
- **OmniRoute**: `http://localhost:20128/`
- **OpenClaw**: `http://localhost:18789/`

## Benefits

1. **Single Entry Point**: Only need to forward port 8080 in GitHub Codespaces
2. **Clean URLs**: No port numbers to remember
3. **Production Ready**: Same setup works in Codespaces and VPS
4. **Backward Compatible**: Direct port access still works

## GitHub Codespaces Usage

When running in Codespaces:

1. Start the container: `make start`
2. In the Ports tab, forward port **8080**
3. Access the forwarded URL - all services available via paths

## Testing

To verify nginx is working:

```bash
# Health check
curl http://localhost:8080/health

# Should return: OK
```

## Technical Details

- Nginx listens on port 8080
- WebSocket support enabled for all services
- Automatic trailing slash redirects
- Large buffer sizes for web app compatibility
- 24-hour timeouts for long-running connections

## Troubleshooting

### Nginx not starting
Check logs:
```bash
docker logs openclaw-webtop | grep nginx
```

### Service not accessible via path
1. Verify service is running on its port
2. Check nginx config: `docker exec openclaw-webtop cat /etc/nginx/sites-available/default`
3. Test direct port access first

### WebSocket issues
Ensure you're using HTTP (not HTTPS) for local testing, or proper SSL termination for production.

## Future Improvements

- [ ] Verify OmniRoute dashboard port (currently assumes 20128)
- [ ] Test subfolder support for ModelRelay/OmniRoute
- [ ] Add SSL/TLS termination option
- [ ] Add authentication layer option
- [ ] Performance tuning for production use

---

**Branch**: `feature/nginx-routing`  
**Status**: Ready for testing  
**Created**: 2026-04-29
