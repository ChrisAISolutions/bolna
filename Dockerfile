FROM python:3.11-slim
WORKDIR /app

# 1. Install system essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt uvicorn

# 3. Copy code
COPY . .

# 4. Networking Env Vars
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# 5. THE STAY-ALIVE COMMAND
# Instead of running the script, we run the Bolna app object directly.
# This ensures it never says "Completed" and keeps the door open.
CMD ["uvicorn", "bolna.server:app", "--host", "0.0.0.0", "--port", "8000"]
