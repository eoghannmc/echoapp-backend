# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 ghcr.io/osgeo/gdal:ubuntu-small-3.8.5

# System: Python & build tools (pip, headers, rtree index)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-dev build-essential \
    libspatialindex-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Upgrade pip tooling
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Python deps
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copy backend sources (app.py, analyses_*.py, utils_*.py, census_api.py, config/)
COPY . .

# Python import path
ENV PYTHONPATH=/app
ENV PORT=8080
EXPOSE 8080

# Run FastAPI
CMD ["python3", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080", "--log-level", "debug"]
