This is a very simple container that will create a cloudflare tunnel for you.

put your cert, uuid.json and config.yml in a folder and bind mount with the docker-compose.yml example below.


version: '3.8'

services:
  app:
    image: netfxtech/cloudflared:latest
    container_name: cloudflared
    volumes:
      - ./app:/etc/cloudflared
    restart: unless-stopped



You can also connect other containers so your tunnel can proxy requests like Traefik/Nginx would.

Run:
docker network create cloudflared

docker-compose:

version: '3.8'

services:
  app:
    image: netfxtech/cloudflared:latest
    container_name: cloudflared
    volumes:
      - ./app:/etc/cloudflared
    networks:
      - cloudflared
    restart: unless-stopped

networks:
  cloudflared:
    external: true



Connect all of your other microservices to the same network and modify your config.yml to proxy to those containers.

# cloudflared