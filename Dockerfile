FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials for voice/telephony
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies (CPU-only version of torch to stay under 4GB)
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy everything from your GitHub
COPY . .

# 4. Critical Environment Setup
# We tell the code to listen on '0.0.0.0' (everyone) and use the Railway PORT
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# 5. THE START COMMAND
# We use 'sh' to make sure the environment variables are passed correctly to the script
CMD ["sh", "-c", "python local_setup/quickstart_server.py --host 0.0.0.0 --port ${PORT:-8000}"]
