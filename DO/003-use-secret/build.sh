

THISFILE=${BASH_SOURCE[0]}
DIR="$( cd "$( dirname "${THISFILE}" )" && pwd -P )"

source "$DIR/.env";

if [ "$1" = "list" ]; then

    curl https://$REGISTRY/v2/$APP/tags/list -u "$USER:$PASSWORD"

    exit $?;
fi

cd docker
docker build -t $APP:$VER .
docker tag $APP:$VER $REGISTRY/$APP:$VER
docker push $REGISTRY/$APP:$VER
cd ..