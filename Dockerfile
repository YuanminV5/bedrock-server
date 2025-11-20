# Stage 1: Download and prepare Minecraft Bedrock Server
FROM ubuntu:22.04 AS downloader

# Replace apt sources with faster mirror
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt to ignore SSL certificate verification
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99verify-peer.conf && \
    echo 'Acquire::https::Verify-Host "false";' >> /etc/apt/apt.conf.d/99verify-peer.conf

# Install certificates first, then other dependencies
RUN apt update && \
    apt install -y wget unzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory for download
WORKDIR /tmp/minecraft

# Download and extract Minecraft Bedrock Server
RUN wget https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-1.21.123.2.zip && \
    unzip bedrock-server-1.21.123.2.zip && \
    rm bedrock-server-1.21.123.2.zip

# Stage 2: Runtime environment
FROM ubuntu:22.04 AS runtime

# Replace apt sources with faster mirror
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/minecraft-bedrock:$LD_LIBRARY_PATH$

# Configure apt to ignore SSL certificate verification
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99verify-peer.conf && \
    echo 'Acquire::https::Verify-Host "false";' >> /etc/apt/apt.conf.d/99verify-peer.conf

# Install certificates first, then runtime dependencies
RUN apt update && \
    apt install -y libcurl4 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /minecraft-bedrock

# Copy server files from downloader stage
COPY --from=downloader /tmp/minecraft/ /minecraft-bedrock/

# Make the bedrock_server executable
RUN chmod +x /minecraft-bedrock/bedrock_server

# Stage 3: Production environment
FROM runtime AS production

# Create non-root user for security
RUN useradd -m -u 1000 minecraft && \
    chown -R minecraft:minecraft /minecraft-bedrock

# Switch to non-root user
USER minecraft

# Expose the default Bedrock server ports
EXPOSE 19132/udp
EXPOSE 19133/udp

# Start the bedrock server directly
CMD ["./bedrock_server"]