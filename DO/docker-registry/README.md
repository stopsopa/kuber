
### Docker registry

Basically this is the Docker Hub (or alternatives), which is a storage solution for docker images. It is some sort of  Github/Bitbucket but for the docker images.


### Docker repository

It is a collection of docker images with the same name and different tags (similar to github repo, commits and tags).

<br />

# Requirements

- docker
- docker-compose
- git

<br />

# Usage

- create a domain for the registry, eg. `docker.domain.com` and point it to your server
- go to this server and:
- `cd /opt/docker-registry/`
- `git clone https://github.com/tomekwlod/docker-registry.git .`
- change secrets in `image/.env` (or copy the .env.prod to .env) and `docker-compose.yml` if needed
- `/bin/bash install.sh`

<br />

Check now if everything is working as expected by visiting one of links:
* `https://docker.domain.com/v2/`

* `https://docker.domain.com/v2/_catalog`

* `https://docker.domain.com/v2/{your-repo-name-here}/tags/list`

* `https://docker.domain.com/v2/twlphaseii/node-jenkins-docker/manifests/latest` <-- to download and see the metadata for the tag

<br />

## Further steps

- `docker login https://d1.domain.com`
- `vi ~/.docker/config.json`   <--- the creds will go here
- `docker tag dd156dd42341 d1.domain.com/docker-image/here`    <--- dd156dd42341 is an image hash
- `docker push d1.domain.com/docker-image/here`

<br />

### todo:
- backup volume (tags/images/...)
