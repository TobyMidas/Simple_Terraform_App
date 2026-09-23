#Stage 1: Builder image
FROM python:3.9-slim AS builder

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY Requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r Requirements.txt

# Copy the rest of the application code into the container
COPY . .
RUN rm Requirements.txt

#Stage 2: Final image
FROM builder AS final

# Set the working directory 
WORKDIR /app

# Copy the application code from the builder image
# Only copy what's actually needed to run
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /app /app


# Expose the port the app runs on
EXPOSE 5000

# Set the command to run the application    
CMD ["python3", "calculate.py"]


