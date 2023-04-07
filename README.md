# Cervantes Docker 

## Lower User Privileges
By building the images locally, `docker-compose` will use these images instead of pulling them from Docker Hub and Microsoft Artifact Registry.

### cervantes-app
- Place the `Dockerfile` file inside the root directory of the Cervantes repository
- Execute `docker build -t mesq/cervantes:latest .` in order create the `mesq/cervantes` image

### cervantes-db and cervantes-nginx
- Create both the `nginx` and `postgres` images by executing the following two commands:
	- `docker build -t nginx:latest -f .\nginx.Dockerfile .`
	- `docker build -t postgres:latest -f .\postgres.Dockerfile .`

## Start the Web Application
Finally, start the web application by running `docker-compose -p cervantes -f .\docker-compose.yml up`. If you wish to start the web application as a deamon, pass the `-d` flag.
