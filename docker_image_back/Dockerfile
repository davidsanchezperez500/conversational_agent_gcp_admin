FROM python:3.14.0rc3-alpine3.22 AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir gunicorn \
    && pip install --no-cache-dir -r requirements.txt
COPY app.py /app/app.py
COPY gunicorn_config.py /app/gunicorn_config.py 

FROM python:3.14.0rc3-alpine3.22

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

WORKDIR /app
ENV PORT=8080

COPY --from=builder /usr/local/bin /usr/local/bin 
COPY --from=builder /usr/local/lib/python3.14/site-packages /usr/local/lib/python3.14/site-packages
COPY --from=builder --chown=appuser:appgroup /app /app

CMD ["gunicorn", "-c", "gunicorn_config.py", "app:app"]
