#FROM node:10
FROM node:10-alpine
# https://github.com/mhart/alpine-node

# to see size difference run:
#$ docker history tapp:0.0.1
#
#IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
#b42de8ae2227        2 months ago        /bin/sh -c #(nop)  CMD ["node" "server.js"]     0B
#1876c0517744        2 months ago        /bin/sh -c #(nop)  EXPOSE 80                    0B
#e78a3b83b6ea        2 months ago        /bin/sh -c #(nop) COPY file:e78b3983ca3aadff…   13kB
#1753b72492b7        2 months ago        /bin/sh -c #(nop) WORKDIR /usr/src/app          0B
#636ef87129d6        3 months ago        /bin/sh -c #(nop)  CMD ["node"]                 0B
#<missing>           3 months ago        /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
#<missing>           3 months ago        /bin/sh -c #(nop) COPY file:238737301d473041…   116B
#<missing>           3 months ago        /bin/sh -c set -ex   && for key in     6A010…   5.47MB
#<missing>           3 months ago        /bin/sh -c #(nop)  ENV YARN_VERSION=1.17.3      0B
#<missing>           3 months ago        /bin/sh -c ARCH= && dpkgArch="$(dpkg --print…   62.7MB
#<missing>           3 months ago        /bin/sh -c #(nop)  ENV NODE_VERSION=10.16.3     0B
#<missing>           3 months ago        /bin/sh -c groupadd --gid 1000 node   && use…   333kB
#<missing>           3 months ago        /bin/sh -c set -ex;  apt-get update;  apt-ge…   562MB
#<missing>           3 months ago        /bin/sh -c apt-get update && apt-get install…   142MB
#<missing>           3 months ago        /bin/sh -c set -ex;  if ! command -v gpg > /…   7.81MB
#<missing>           3 months ago        /bin/sh -c apt-get update && apt-get install…   23.2MB
#<missing>           3 months ago        /bin/sh -c #(nop)  CMD ["bash"]                 0B
#<missing>           3 months ago        /bin/sh -c #(nop) ADD file:9788b61de35351489…   101MB
#
#$ docker history tapp:0.0.3
#
#IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
#a96e1e3216b0        58 seconds ago      /bin/sh -c #(nop)  CMD ["node" "server.js"]     0B
#56572211296c        59 seconds ago      /bin/sh -c #(nop)  EXPOSE 80                    0B
#e725eebb8c50        59 seconds ago      /bin/sh -c #(nop) COPY file:e78b3983ca3aadff…   13kB
#97a1f5ebf46b        59 seconds ago      /bin/sh -c #(nop) WORKDIR /usr/src/app          0B
#a5b5a1e3a8cb        3 days ago          /bin/sh -c #(nop)  CMD ["node"]                 0B
#<missing>           3 days ago          /bin/sh -c #(nop)  ENTRYPOINT ["docker-entry…   0B
#<missing>           3 days ago          /bin/sh -c #(nop) COPY file:238737301d473041…   116B
#<missing>           3 days ago          /bin/sh -c apk add --no-cache --virtual .bui…   5.35MB
#<missing>           3 days ago          /bin/sh -c #(nop)  ENV YARN_VERSION=1.21.1      0B
#<missing>           3 days ago          /bin/sh -c addgroup -g 1000 node     && addu…   69.6MB
#<missing>           3 days ago          /bin/sh -c #(nop)  ENV NODE_VERSION=10.18.0     0B
#<missing>           4 days ago          /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
#<missing>           4 days ago          /bin/sh -c #(nop) ADD file:c7d28fcb71c026d79…   5.59MB

# Create app directory
WORKDIR /usr/src/app

COPY server.js .

EXPOSE 80

CMD [ "node", "server.js" ]


