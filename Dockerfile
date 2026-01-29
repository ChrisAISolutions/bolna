# Stage 1: Build stage (The heavy lifting)
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies needed for building only
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install dependencies to a specific folder
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Final image (The slim version)
FROM python:3.11-slim

WORKDIR /app

# Install ONLY the runtime tools you need (like ffmpeg)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Copy only the installed python packages from the builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Make sure the installed packages are in the system path
ENV PATH=/root/.local/bin:$PATH

CMD ["python", "main.py"]
