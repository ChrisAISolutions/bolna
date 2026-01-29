FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials for voice (ffmpeg)
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt uvicorn

# 3. Copy everything
COPY . .

# 4. Set the "Brain" path so it can find the 'bolna' folder
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# 5. THE START COMMAND: Use the Quickstart Server you found
# This will listen on the port Railway provides.
CMD ["sh", "-c", "python local_setup/quickstart_server.py"]
