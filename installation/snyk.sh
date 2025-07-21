#!/bin/bash

curl https://static.snyk.io/cli/latest/snyk-linux -o snyk 
chmod +x ./snyk 
sudo mv ./snyk /usr/local/bin/

