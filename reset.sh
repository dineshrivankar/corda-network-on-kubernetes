#!/bin/sh

# Remove all the Pods 
kubectl delete all --all

# Terminate exited containers
docker rm -f $(docker ps -aq -f status=exited)

