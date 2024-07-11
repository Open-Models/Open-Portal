# Portal Installation

You can build your own open portal to bring together the open resources you use or want to provide. This guide will help
you set up a portal locally or for a website.

## Dependencies

The website is rendered by Quarto, first follow their [installation instructions](https://quarto.org/docs/get-started/) for your device.

**Using Linux (Debian)**:
```bash
# Basic apt dependencies
sudo apt update
sudo apt install git

# Install Quarto
VERSION=1.4.554

wget https://github.com/quarto-dev/quarto-cli/releases/download/v$VERSION/quarto-$VERSION-linux-amd64.deb
sudo apt install ./quarto-$VERSION-linux-amd64.deb
```

## Local Portal

Use the following steps to download and start the portal locally.

```bash
# Download portal repository
git clone https://github.com/Open-Models/Open-Portal.git

# Go into the repository folder
cd Open-Portal

# Render html website (generated in the _site folder)
quarto render
```

The portal can be then published with any web server. The command `quarto preview` can be used to display the website locally.

> **Warning**: Quarto do not use `README.md` files by default as `index.html` (see
> [quarto-dev/quarto-cli#1615](https://github.com/quarto-dev/quarto-cli/issues/1615),
> for now you can fix the home page with the following command: `rm index.html && ln -s README.html index.html`

## Using Docker

The portal can be installed using docker containers. If needed, see installation instructions from [Docker
website](https://docs.docker.com/engine/install/).

**Steps to launch the portal:**
```bash
git clone https://github.com/Open-Models/Open-Portal
cd Open-Portal

sudo docker build -t portal-image .
sudo docker run --name portal -p 80:80 portal-image
```

The portal is created using sources of the local repository.

**To initiate a portal served under https:**
```bash
sudo docker build --build-arg HTTPS=true -t portal-image .
sudo docker run -e DOMAIN=portal.organisation.org -e MAIL=you@email.org --restart always -p 80:80 -p 443:443 portal-image
```

`HTTPS`, `DOMAIN` & `MAIL` variables are required to obtain an SSL certificate using let's encrypt.

**To update manually a running container**:
```bash
sudo docker exec CONTAINER git pull
sudo docker exec CONTAINER quarto render --output-dir=html
sudo docker exec CONTAINER sh -c 'cd html && ln -sf README.html index.html'
```
