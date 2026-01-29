FROM python:3.11-slim
WORKDIR /app

# 1. Install system essentials for Bolna
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy your code from GitHub
COPY . .

# 4. Set critical environment variables for Cloud hosting
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
# Force the app to bind to all network interfaces
ENV HOST=0.0.0.0
# Use the port Railway assigns (usually 8000)
ENV PORT=8000

# 5. THE START COMMAND: 
# We use 'sh' to ensure the $PORT variable is read correctly by the script.
# This points exactly to the quickstart_server.py you found.
# Replace your current CMD with this one:
CMD ["sh", "-c", "python local_setup/quickstart_server.py --host 0.0.0.0 --port 8000 & tail -f /dev/null"]
