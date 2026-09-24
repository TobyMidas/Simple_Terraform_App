# Stage 1: Builder image
FROM python:3.12-slim AS builder

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Requirements.txt .
RUN pip3 install --no-cache-dir -r Requirements.txt

COPY . .
RUN rm Requirements.txt

# Stage 2: Final image (clean base, no build tools)
FROM python:3.12-slim AS final

RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

EXPOSE 3000

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "--workers", "2", "calculate:app"]