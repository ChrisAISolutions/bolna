FROM python:3.11-slim
WORKDIR /app

# 1. Install essentials
RUN apt-get update && apt-get install -y build-essential ffmpeg && rm -rf /var/lib/apt/lists/*

# 2. Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir torch torchaudio --index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir -r requirements.txt uvicorn

# 3. Copy your code
COPY . .

# 4. Networking Env Vars
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

# 5. THE STAY-ALIVE COMMAND
# We use uvicorn to run the server module so it never "completes"
CMD ["uvicorn", "bolna.server:app", "--host", "0.0.0.0", "--port", "8000"]
