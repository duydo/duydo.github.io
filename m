#!/usr/bin/env bash
me=$(basename "$0")


publish() {
    rm -rf ./public
    hugo
    cp ./CNAME ./public/CNAME
    export GIT_DEPLOY_DIR=public
    export GIT_DEPLOY_BRANCH=master
    export GIT_DEPLOY_USERNAME="duydo"
    export GIT_DEPLOY_EMAIL=doquocduy@gmail.com
    ./bin/deploy.sh
    rm -rf ./public
}

run() {
  hugo server -w --verbose $@
}


help() {
  cat << EOF
    ${me}: start server
    ${me} s: commit then push to develop branch
    ${me} p: publish to master branch
EOF
}

case "$1" in
    -h) help;;
    r) run;;
    s)
        rm -rf ./public
        git add --all && git commit -am "$2" && git push
        ;;
    p) publish;;
    *) run;;

esac
exit 0
