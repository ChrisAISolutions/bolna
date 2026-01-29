FROM python:3.11-slim
WORKDIR /app

# Install system essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy your requirements
COPY requirements.txt .

# Install the CPU-only AI libraries (This keeps you under 4GB)
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install everything else
RUN pip install --no-cache-dir -r requirements.txt

# Copy your code
COPY . .

# Set the path so Bolna can find its own folders
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# The Bolna start command
CMD ["python", "-m", "bolna.assistant"]
