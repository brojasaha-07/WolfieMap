# Docker Setup for Wolfie2D

This project includes Docker configuration for easy containerization and deployment.

## Files

- **Dockerfile** - Production-optimized multi-stage build
- **Dockerfile.dev** - Development image with hot-reload
- **docker-compose.yml** - Production container orchestration
- **docker-compose.dev.yml** - Development container orchestration
- **.dockerignore** - Excludes unnecessary files from Docker build

## Quick Start

### Production Build

Build and run the production image:

```bash
# Build the image
docker build -t wolfie2d:latest .

# Run the container
docker run -p 8080:8080 wolfie2d:latest

# Or use docker-compose
docker-compose up --build
```

The application will be available at `http://localhost:8080`

### Development with Hot Reload

For development with automatic rebuild on code changes:

```bash
# Using docker-compose (recommended)
docker-compose -f docker-compose.dev.yml up --build

# Or manually with Dockerfile.dev
docker build -f Dockerfile.dev -t wolfie2d:dev .
docker run -p 8080:8080 -v $(pwd):/app wolfie2d:dev
```

## Features

- **Multi-stage build**: Smaller production image
- **Alpine base**: Lightweight Node.js images
- **Health checks**: Automatic container health monitoring
- **CORS enabled**: Development-friendly HTTP server
- **Hot reload**: Development image rebuilds on file changes
- **Volume mounting**: Development container shares source with host

## Environment Variables

- `NODE_ENV` - Set to `production` or `development` (automatically set by docker-compose)

## Ports

- **8080** - Application port (both dev and production)

## Building from Docker Hub

To push the image to Docker Hub:

```bash
docker tag wolfie2d:latest yourusername/wolfie2d:latest
docker push yourusername/wolfie2d:latest
```

## Troubleshooting

### Container exits immediately
Check the logs:
```bash
docker logs <container_id>
```

### Port already in use
Change the port mapping:
```bash
docker run -p 8081:8080 wolfie2d:latest
```

### Build fails with npm errors
Try cleaning and rebuilding:
```bash
docker-compose down
docker system prune
docker-compose up --build
```

## Container Structure

### Production Image
```
├── Node.js 18 Alpine
├── npm dependencies
├── Compiled TypeScript
└── HTTP Server (port 8080)
```

### Development Image
```
├── Node.js 18 Alpine
├── npm dependencies
├── Full source code (mounted)
├── Gulp watch process
└── HTTP Server (port 8080)
```
