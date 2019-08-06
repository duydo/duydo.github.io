#!/usr/bin/env bash
me=$(basename "$0")


function publish() {
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

function run_hugo() {
  hugo server -D -w --verbose
}

case "$1" in
    r)
        run_hugo
        ;;
    s)
        rm -rf ./public
        git add --all && git commit -am "$2" && git push
        ;;
    p)
        publish
        ;;
    *)
      run_hugo
      ;;

esac
exit 0
