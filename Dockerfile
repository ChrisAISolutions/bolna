# Use Python 3.11
FROM python:3.11-slim

# Install system dependencies (ffmpeg is required for Bolna/audio)
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

# Start the application
CMD ["python", "main.py"]
