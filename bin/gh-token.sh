#!/bin/sh

curl -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/user -i
