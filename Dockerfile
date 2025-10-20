# Base image (small, secure)
FROM python:3.10-slim AS base

# Avoid .pyc files and enable unbuffered stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (for Docker cache efficiency)
COPY app/requirements.txt ./requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY app/ ./app/

# Create a non-root user
RUN useradd -m appuser \
    && chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose app port
EXPOSE 8080

# Run the application
CMD ["python", "app/app.py"]
