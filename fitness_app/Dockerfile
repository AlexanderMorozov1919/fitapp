# Use a lightweight Python image for serving static files
FROM python:3.11-alpine

# Set working directory
WORKDIR /app

# Copy built web files (assumes build/web directory exists)
COPY build/web /app

# Expose port 8080
EXPOSE 8080

# Start Python HTTP server
CMD ["python3", "-m", "http.server", "8080"]