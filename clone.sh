#!/usr/bin/env bash
if [[ -z "$TRAVIS_BUILD_DIR" ]];
    then
        export TRAVIS_BUILD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
        echo "Setting TRAVIS_BUILD_DIR to: $TRAVIS_BUILD_DIR"
    else
       echo "Using pre-set TRAVIS_BUILD_DIR: $TRAVIS_BUILD_DIR"
fi
if [[ -z "$TRAVIS_COMMIT_MESSAGE" ]];
    then
        echo "Please set TRAVIS_COMMIT_MESSAGE env!"
        exit 1;
    else
       echo "Using pre-set TRAVIS_COMMIT_MESSAGE: $TRAVIS_COMMIT_MESSAGE"
fi
source ${TRAVIS_BUILD_DIR}/set_environmental_variables.sh
echo "Checking out revision ${SHA}"
if [[ ! -d "${REPO_TO_TEST}" ]];
    then
        echo "${REPO_TO_TEST} repo not found so cloning" && set -x
        git clone -b ${BRANCH} --recurse-submodules --single-branch https://${GITHUB_ACCESS_TOKEN}:x-oauth-basic@github.com/mikepsinn/${REPO_TO_TEST}.git ${REPO_TO_TEST};
fi
if [[ ! -d "${REPO_TO_TEST}" ]];
    then
        echo "Clone of ${BRANCH} branch failed so cloning develop branch" && set -x;
        git clone -b develop --recurse-submodules --single-branch https://${GITHUB_ACCESS_TOKEN}:x-oauth-basic@github.com/mikepsinn/${REPO_TO_TEST}.git ${REPO_TO_TEST};
fi
set -x
cd ${REPO_TO_TEST} && git stash && git pull origin ${BRANCH}
git submodule update --init --recursive
chmod +x tests/travis/*.sh
