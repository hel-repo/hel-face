#!/bin/bash
set -x  # Show the output for debug

if [ $TRAVIS_BRANCH == 'master' ] ; then
    # Initialize a new git repo in ./dist/, and push it to our server.
    cd dist
    git init

    git remote add deploy "travis@fomalhaut.me:/home/totoro/fomalhaut/hel"
    git config user.name "Travis CI"
    git config user.email "murky.owl@gmail.com"

    git add .
    git commit -m "Deploy"
    git push --force deploy master
else
    echo "Not deploying, since this branch isn't master."
fi
