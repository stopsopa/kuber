
# run form main directory like:
#     /bin/bash bash/gitwormhole/run.sh pull
# pwd will point to root directory - NOT this 'bash/gitwormhole' directory


THISFILE=${BASH_SOURCE[0]}
DIR="$( cd "$( dirname "${THISFILE}" )" && pwd -P )"

source "$DIR/../libs/colours.sh"

if [ $# -lt 1 ] ; then

    red "give git repository name to push latest scripts like:"
    red "\n    /bin/bash $0 git@github.com:user/name.git\n\n"

    exit 1;
fi

#exit 0;

yellow "\ngitwormhole push:\n"

LIST=(
    "."
    ".git"
    ".gitignore"
    "react/servers"
    "react/servers/index.js"
    "public/dist"
    "public/dist/admin.bundle.js"
);

for i in "${LIST[@]}"
do
    green "testing read & write access: $i"

    if [ ! -w "$i" ] || [ ! -r "$i" ]; then  # not exist (fnode, directory, socket, etc.)
        red "'$i' is not writtable | readable"
        exit 1
    fi
done

echo ""

#exit 0;

set -e
set -x

# cache dir vvv
    TEMPORARY="____mainrepogitfiles-cached";

    if [ -e "$TEMPORARY" ]; then

        rm -rf "$TEMPORARY";
    fi

    if [ -e "$TEMPORARY" ]; then

        red "can't delete directory $TEMPORARY"
        exit 1
    fi

    mkdir $TEMPORARY;

    if [ ! -e "$TEMPORARY" ]; then

        red "can't create directory $TEMPORARY"
        exit 1
    fi
# cache dir ^^^

# tmp git dir vvv
    TMPGITDIR="____tmpgitdir";

    if [ -e "$TMPGITDIR" ]; then

        rm -rf "$TMPGITDIR";
    fi

    if [ -e "$TMPGITDIR" ]; then

        red "can't delete directory $TMPGITDIR"
        exit 1
    fi

    mkdir $TMPGITDIR;

    if [ ! -e "$TMPGITDIR" ]; then

        red "can't create directory $TMPGITDIR"
        exit 1
    fi
# tmp git dir ^^^

function cleanup {

    set +e
    set -x

    yellow "    executing cleanup"

    if [ ! -e "$TEMPORARY" ]; then

        red "can't run cleanup function because directory $TEMPORARY doesn't exist";
        exit 1
    fi

    if [ ! -e "$TEMPORARY/.git" ]; then

        red "can't run cleanup function because directory $TEMPORARY/.git doesn't exist";
        red "\n\n    restore manually content of directory $TEMPORARY back to $(dirname $TEMPORARY)\n\n"

        exit 1
    fi

    if [ ! -e "$TEMPORARY/.gitignore" ]; then

        red "can't run cleanup function because directory $TEMPORARY/.gitignore doesn't exist";
        red "\n\n    restore manually content of directory $TEMPORARY back to $(dirname $TEMPORARY)\n\n"

        exit 1
    fi

    rm -rf .git
    rm -rf .gitignore
    mv "$TEMPORARY/.git" .git
    mv "$TEMPORARY/.gitignore" .gitignore

        mv "$TEMPORARY/public.gitignore" public/.gitignore
        mv "$TEMPORARY/react.gitignore" react/.gitignore
        mv "$TEMPORARY/react.servers.gitignore" react/servers/.gitignore
        mv "$TEMPORARY/app.preprocessor.gitignore" app/preprocessor/.gitignore;

    if [ -e "$TMPGITDIR" ]; then

        rm -rf "$TMPGITDIR"
    fi

    if [ -e "$TMPGITDIR" ]; then

        red "Can't delete $TMPGITDIR directory"

        exit 1
    fi

    if [ -e "$TEMPORARY" ]; then

        rm -rf "$TEMPORARY"
    fi

    if [ -e "$TEMPORARY" ]; then

        red "Can't delete $TEMPORARY directory"

        exit 1
    fi

    green "    seems like cleanup() was successful"
}

trap cleanup EXIT

mv .git "$TEMPORARY/"

mv .gitignore "$TEMPORARY/"

    # after .git .gitignore copying because if it will crash then it will be able to revert smoothly
    mv public/.gitignore "$TEMPORARY/public.gitignore";
    mv react/.gitignore "$TEMPORARY/react.gitignore";
    mv react/servers/.gitignore "$TEMPORARY/react.servers.gitignore";
    mv app/preprocessor/.gitignore "$TEMPORARY/app.preprocessor.gitignore";

(cd "$TMPGITDIR" && git clone $1 .);

mv "$TMPGITDIR/.git" .

mv "$TMPGITDIR/.gitignore" .

make prod

git add .
git commit --amend --no-edit
git push origin master --force

# clear trap
trap - EXIT

cleanup

green "gitwormhole push : all good, finished"






