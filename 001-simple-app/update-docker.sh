
THISFILE=${BASH_SOURCE[0]}
DIR="$( cd "$( dirname "${THISFILE}" )" && pwd -P )"

set -e
set -x

LAST="$(/bin/bash "$DIR/last-version.sh")"

NEXT="$(/bin/bash "$DIR/../bash/deploy/semver.sh" "$LAST" patch)"

sed -i -r -E  "s/release: ([a-z]*[0-9]+\.[0-9]+\.[0-9]+)/release: $NEXT/g" docker/image/server.js

TAG="$(cd "$DIR/docker/image" && docker build -q -t piiapp:$NEXT .)"

# sha256:92b3d46e063c8af9649fa9d2e12d8be74fefa131f4ba04cf45e120fc38d6d760

TEST="^sha256:([a-f0-9]{10}).*$"

HASH=""

if [[ $TAG =~ $TEST ]]; then

    HASH=${BASH_REMATCH[1]}

else

    echo -e "Can't extract hash";

    exit 1
fi

docker tag $HASH sdpii/piiapp:$NEXT

docker push sdpii/piiapp:$NEXT

node "$DIR/../bash/node/yml/set.js" ../../../001-simple-app/kubernetes/piiapp.yaml spec.template.spec.containers.0.image "sdpii/piiapp:$NEXT"

cat << EOF

  # push file piiapp.yaml

  kub0
  su kuber
  kubectl apply -f test/2019-attempt-2/001-simple-app/kubernetes/piiapp.yaml
  kubectl get pods

  # helpers
  kubectl get services
  

EOF




