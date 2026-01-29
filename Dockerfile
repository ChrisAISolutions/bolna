FROM python:3.11-slim
WORKDIR /app

# Install system essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
# We manually add 'uvicorn' just in case it's missing from your requirements
RUN pip install --no-cache-dir -r requirements.txt uvicorn 

# Copy your code
COPY . .

# Set paths
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# This command starts a real web server on the port Railway expects
# We try to run the 'assistant' as an app. 
CMD ["sh", "-c", "uvicorn bolna.assistant:app --host 0.0.0.0 --port ${PORT:-8000}"]
