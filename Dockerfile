# Base image (small, secure)
FROM python:3.10-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (from app folder)
COPY app/requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

RUN useradd -m appuser
USER appuser

EXPOSE 8080

CMD ["python", "app/app.py"]
