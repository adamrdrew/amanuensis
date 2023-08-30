# Start from the Fedora base image
FROM fedora:latest AS setup

# Create user, set up directories
RUN useradd -u 1001 -G 0 -ms /bin/bash coder && \
    mkdir -p /home/coder/.ssh /home/coder/.gnupg && \
    chown -R 1001:0 /home/coder && \
    chmod 700 /home/coder/.ssh /home/coder/.gnupg && \
    chmod -R g=u /home/coder

# Copy to final image
FROM codercom/code-server:latest

# Copy user setup
COPY --from=setup /home/coder /home/coder

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Switch to non-root user
USER 1001

# Use the entry script
ENTRYPOINT [ "/entrypoint.sh" ]
