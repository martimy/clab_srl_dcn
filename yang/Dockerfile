FROM python:3.8-slim-buster

# Update the package repository, install necessary packages, and clean up
RUN apt-get update && apt-get install -y \
    libyang-dev \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

# Install pyang
RUN pip3 install --no-cache-dir pyang

# Set the working directory
WORKDIR /app

# Command to run when the container starts
CMD ["/bin/bash"]
