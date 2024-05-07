FROM nginx:latest

# Configuration variable for HTTPS (through Let's Encrypt)
ARG HTTPS=false
ENV DOMAIN=organisation.org
ENV MAIL=someone@organisation.org

# Use of HTTP & HTTPS ports
EXPOSE 80
EXPOSE 443

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget git

# Install Quarto
ARG QUARTO_VERSION=1.4.554
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-$QUARTO_VERSION-linux-amd64.deb && \
    apt install -y ./quarto-$QUARTO_VERSION-linux-amd64.deb && \
    rm quarto-$QUARTO_VERSION-linux-amd64.deb

# Dependencies to enable HTTPS with Let's Encrypt
RUN if [ "$HTTPS" = "true" ]; then \
    apt-get update && \
    apt-get install -y certbot; \
    fi

# Use of local sources of the repository to launch the portal
COPY . /usr/share/portal
WORKDIR /usr/share/portal

RUN quarto render --output-dir html && \
    # Fix of README not used as index by quarto \
    cd html && ln -sf README.html index.html

ENTRYPOINT ["/usr/share/portal/entrypoint.sh"]
