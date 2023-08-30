FROM codercom/code-server:latest

RUN useradd -u 1001 -G 0 -ms /bin/bash coder && \
    chown -R 1001:0 /home/coder && \
    chmod -R g=u /home/coder

RUN mkdir -p /home/coder/.ssh /home/coder/.gnupg && \
    chown -R 1001:0 /home/coder/.ssh /home/coder/.gnupg && \
    chmod 700 /home/coder/.ssh /home/coder/.gnupg

USER 1001

CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]