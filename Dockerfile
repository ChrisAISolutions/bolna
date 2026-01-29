FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies (CPU-only version of torch to keep the image slim)
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy your project files
COPY . .

# 4. Critical Cloud Networking Variables
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# 5. THE START COMMAND
# This uses the port provided by Railway ($PORT) or defaults to 8000.
CMD ["sh", "-c", "python local_setup/quickstart_server.py --host 0.0.0.0 --port ${PORT:-8000}"]
