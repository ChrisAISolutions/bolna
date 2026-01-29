# Stage 1: Build environment
FROM python:3.11-slim AS builder
WORKDIR /app

# Install build tools
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# 1. Install the "Slim" CPU versions of the heavy libraries first
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir onnxruntime optimum --user

# 2. Install everything else from your list
RUN pip install --no-cache-dir --user -r requirements.txt

# Stage 2: Clean Runtime environment
FROM python:3.11-slim
WORKDIR /app

# Install ffmpeg (required for Bolna audio)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy only the necessary files from the builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the app can see the installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

CMD ["python", "main.py"]
