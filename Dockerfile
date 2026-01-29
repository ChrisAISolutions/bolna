FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy your project files
COPY . .

# 4. Critical Cloud Networking
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# 5. THE START COMMAND
# This runs the quickstart server but adds a 'wait' command so it stays ACTIVE.
CMD ["sh", "-c", "python local_setup/quickstart_server.py --host 0.0.0.0 --port 8000 & sleep infinity"]

