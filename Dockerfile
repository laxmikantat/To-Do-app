# Base image (small, secure)
FROM python:3.10-slim AS base

# Prevent Python from writing .pyc files and buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies (optional if your app needs them)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (for Docker layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

# Create a non-root user (security best practice)
RUN useradd -m appuser
USER appuser

# Expose app port
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
