# IpynbDockerTemplate

This is a Ipynb Docker Template.  
The notebook user (NB_USER) in the container is bound on uid and gid of a local machine user.  
It's to specified in `.env` file.  
Also, this directory bind to volumes.  

Base Images:
- <https://hub.docker.com/r/jupyter/datascience-notebook>

## How to use

```sh
cp .env.sample .env
# Specify your environments
vi .env
docker-compose build
docker-compose up -d
docker-compose down
```

