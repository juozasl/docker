#!/bin/bash

# build all images

docker build -t mongodb:local mongodb/

docker build -t dbhost:local dbhost/


