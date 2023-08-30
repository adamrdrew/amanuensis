# Start with a Fedora base to set up user and permissions
FROM fedora:latest AS setup

# Create user and setup directories
RUN useradd -u 1001 -G 0 -ms /bin/bash coder && \
    mkdir -p /home/coder/.ssh /home/coder/.gnupg && \
    chown -R 1001:0 /home/coder && \
    chmod 700 /home/coder/.ssh /home/coder/.gnupg && \
    chmod -R g=u /home/coder

# Start with the base code-server image
FROM codercom/code-server:latest

# Copy user and directory setup from the Fedora image
COPY --from=setup /home/coder /home/coder

# Switch to non-root user
USER 1001

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
