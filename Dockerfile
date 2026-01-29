# --- Stage 1: The Builder (Heavy Lifting) ---
FROM python:3.11-slim AS builder
WORKDIR /app

# Install build tools briefly
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# THE SECRET SAUCE: Install CPU-only versions to save 4GB+ 
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install the rest of your requirements to the .local folder
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2: The Final Lean Image ---
FROM python:3.11-slim
WORKDIR /app

# Install only what's needed for the app to run (like ffmpeg for audio)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy only the installed packages (no caches, no build tools)
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the app can see the installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

CMD ["python", "main.py"]
