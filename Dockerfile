# --- Stage 1: The Builder (Keeping things light) ---
FROM python:3.11-slim
WORKDIR /app

# Install essentials (ffmpeg is key for AI voice)
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy requirements and install the 'diet' version of AI libraries
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt

# Copy all your files from GitHub to the Cloud
COPY . .

# Set the environment so the cloud knows where the 'bolna' folder is
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# THE COMMAND: This starts the Bolna assistant and KEEPS IT RUNNING.
# It uses the port Railway wants (8000) automatically.
CMD ["sh", "-c", "python -m bolna.assistant || tail -f /dev/null"]
