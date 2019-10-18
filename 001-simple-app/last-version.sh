
VER="$(docker images | grep piiapp | awk '{print $2}' | node ../bash/node/sortsemver.js | tail -n 1)"

TEST="^([0-9]+)\.([0-9]+)\.([0-9]+)(.*)$"

if ! [[ $VER =~ $TEST ]]; then

    echo -e "VER: should match regex '$TEST' but it is >>>$VER<<<";

    exit 1
fi

echo $VER