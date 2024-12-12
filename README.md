# Ipynb Docker Template

This is a Ipynb Docker Template.  
The container is bind on specified a local machine user by `.env` file.  
Also, this directory bind mount to volumes.  

## Usage

```sh
git clone $REPO_URL
cd IpynbDockerTemplate
# Specify your environments
vi .env
docker compose build
docker compose up -d
docker compose exec app sh
docker compose down
```
