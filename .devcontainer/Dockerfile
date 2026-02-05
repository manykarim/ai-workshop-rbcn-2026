FROM mcr.microsoft.com/devcontainers/python:3.13

RUN sudo apt-get update && sudo apt-get install -y \
    wget \
    gnupg \
    && sudo rm -rf /var/lib/apt/lists/*

# Download Google signing key and feed it directly to gpg.
RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg

RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main' \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list

RUN sudo apt-get update && sudo apt-get install -y google-chrome-stable firefox-esr

RUN echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-userns.conf

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
