# --- Stage 1: The Builder (Heavy Lifting) ---
FROM python:3.11-slim AS builder
WORKDIR /app

# Install build tools
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# THE MAGIC: Install CPU-only versions to stay under the 4GB limit
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install the rest of your requirements
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2: The Final Lean Image ---
FROM python:3.11-slim
WORKDIR /app

# Install ffmpeg (required for Bolna audio)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy only the installed packages
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the app can see the installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# BOLNA START COMMAND: This starts the Bolna assistant module
CMD ["python", "-m", "bolna.assistant"]
