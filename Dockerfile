# --- Stage 1: The Builder (Heavy Lifting) ---
FROM python:3.11-slim AS builder
WORKDIR /app

# Install build tools briefly
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# THE MAGIC: Install CPU-only versions to stay under the 4GB limit
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install the rest of your requirements
RUN pip install --no-cache-dir --user -r requirements.txt

# --- Stage 2: The Final Lean Image ---
FROM python:3.11-slim
WORKDIR /app

# Install ffmpeg (required for Bolna audio processing)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy only the installed packages from the builder
COPY --from=builder /root/.local /root/.local
COPY . .

# Ensure the app can see the installed packages
ENV PATH=/root/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# This command looks for main.py, and if not found, tries app.py
CMD ["sh", "-c", "python main.py || python app.py || python bolna_server.py"]
