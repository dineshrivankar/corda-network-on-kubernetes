#!/bin/bash

source .env

# ---------------------------------------------------------------------------
# Change Hostnames for all parties
# ---------------------------------------------------------------------------
echo
echo -e "\e[1;33mNode Configuration chanages... \e[0m"
sed -i '/kubernetes.io\/\hostname/c\          \kubernetes.io\/\hostname\: \'$NOTARY_HOSTNAME'' notary.yaml
sed -i '/kubernetes.io\/\hostname/c\          \kubernetes.io\/\hostname\: \'$PARTYA_HOSTNAME'' partya.yaml
sed -i '/kubernetes.io\/\hostname/c\          \kubernetes.io\/\hostname\: \'$PARTYB_HOSTNAME'' partyb.yaml

sed -i '/image/c\          \image\: \'$DOCKER_IMAGE_NAME'' notary.yaml
sed -i '/image/c\          \image\: \'$DOCKER_IMAGE_NAME'' partya.yaml
sed -i '/image/c\          \image\: \'$DOCKER_IMAGE_NAME'' partyb.yaml

# ---------------------------------------------------------------------------
# Docker login
# ---------------------------------------------------------------------------
echo
echo -e "\e[1;33mDocker Login... \e[0m"
docker login

# ---------------------------------------------------------------------------
# Build docker image
# ---------------------------------------------------------------------------
echo
echo -e "\e[1;33mBuild docker image of Corda Node... \e[0m"
docker build --tag $DOCKER_IMAGE_NAME .

# ---------------------------------------------------------------------------
# Push docker image
# ---------------------------------------------------------------------------
echo
echo -e "\e[1;33mPush docker image of Corda Node... \e[0m"
docker push $DOCKER_IMAGE_NAME

# ---------------------------------------------------------------------------
# Remove all the Pods 
# ---------------------------------------------------------------------------
kubectl delete all --all

# ---------------------------------------------------------------------------
# Terminate exited containers
# ---------------------------------------------------------------------------
docker rm -f $(docker ps -aq -f status=exited)

# ---------------------------------------------------------------------------
# Deploy network
# ---------------------------------------------------------------------------
kubectl apply -f .

