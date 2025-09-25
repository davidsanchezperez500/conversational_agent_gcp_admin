import os
import multiprocessing

# ==============================================================================
# 1. Socket and Worker Configuration
# ==============================================================================

# Bind: Listens on the port provided by the Cloud Run environment variable PORT.
# It defaults to 8080 if PORT is somehow not set.
bind = f"0.0.0.0:{os.environ.get('PORT', '8080')}"

# Workers: Number of Gunicorn worker processes. 
# Formula: (2 * CPU Cores) + 1. Cloud Run typically gives 1 CPU, so 3 is a good starting point.
workers = (multiprocessing.cpu_count() * 2) + 1 

# Threads: Threads per worker. Ideal for Python web frameworks handling I/O (like Bigtable access).
threads = 8 

# Worker Class: Use gthread (Gevent or Asyncio are optional but gthread is standard for Flask/synchronous I/O).
worker_class = 'gthread'


# ==============================================================================
# 2. Timeout and Logging Configuration
# ==============================================================================

# Timeout (Seconds): Maximum time Gunicorn waits for a response. 
# Set to the maximum allowed by Cloud Run (default 300s or 5 minutes) to avoid premature termination.
timeout = 300

# Keepalive (Seconds): Time to keep inactive connections open (useful when behind a Load Balancer).
keepalive = 5

# Logging: Send access and error logs to stdout/stderr so Cloud Run collects them automatically.
accesslog = "-"
errorlog = "-"
