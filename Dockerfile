FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt uvicorn

# 3. Copy code
COPY . .

# 4. Environment setup
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# 5. THE FIX: Running the actual Bolna API Server
# This is what makes the "Application failed to respond" error go away.
CMD ["python", "bolna/server.py"]
