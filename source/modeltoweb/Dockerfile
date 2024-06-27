FROM debian:12

ENV QT_QPA_PLATFORM="offscreen"
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and add QGIS repository keyring
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates && \
    mkdir -p /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg

# Add the QGIS repository to sources list
RUN echo "Types: deb deb-src" > /etc/apt/sources.list.d/qgis.sources && \
    echo "URIs: https://qgis.org/debian" >> /etc/apt/sources.list.d/qgis.sources && \
    echo "Suites: bookworm" >> /etc/apt/sources.list.d/qgis.sources && \
    echo "Architectures: amd64" >> /etc/apt/sources.list.d/qgis.sources && \
    echo "Components: main" >> /etc/apt/sources.list.d/qgis.sources && \
    echo "Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg" >> /etc/apt/sources.list.d/qgis.sources

# Update package list and install QGIS
RUN apt-get update && apt-get install -y qgis

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default command to run when starting the container
RUN apt-get install -y python3-pip
RUN pip install firebase-admin --break-system-packages

WORKDIR /root

COPY main.py /root/main.py

CMD ["/bin/bash"]
