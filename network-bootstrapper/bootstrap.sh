#!/bin/sh

source ../.env

# ---------------------------------------------------------------------------
# Clear screen
# ---------------------------------------------------------------------------
clear

# ---------------------------------------------------------------------------
# Delete old node directories and log files
# ---------------------------------------------------------------------------
rm -rf notary/ partya/ partyb/ checkpoints* diagnostic* node*

# ---------------------------------------------------------------------------
# Network Bootstrapper 
# ---------------------------------------------------------------------------
wget https://repo1.maven.org/maven2/net/corda/corda-tools-network-bootstrapper/4.5/corda-tools-network-bootstrapper-4.5.jar
java -jar corda-tools-network-bootstrapper-4.5.jar 

# --------------------------------------------------------------------------
# Delete all secrets
# --------------------------------------------------------------------------
kubectl delete secrets/partya-config secrets/partyb-config secrets/notary-config secrets/partya-keystore secrets/partyb-keystore secrets/notary-keystore  2>/dev/null # if no secret present the suppress error output

# --------------------------------------------------------------------------
# Create new secrets
# --------------------------------------------------------------------------
kubectl create secret generic partya-config --from-file=./partya/node.conf --from-file=./partya/network-parameters
kubectl create secret generic partyb-config --from-file=./partyb/node.conf --from-file=./partyb/network-parameters
kubectl create secret generic notary-config --from-file=./notary/node.conf --from-file=./notary/network-parameters

kubectl create secret generic partya-keystore --from-file=./partya/certificates/nodekeystore.jks --from-file=./partya/certificates/sslkeystore.jks --from-file=./partya/certificates/truststore.jks
kubectl create secret generic partyb-keystore --from-file=./partyb/certificates/nodekeystore.jks --from-file=./partyb/certificates/sslkeystore.jks --from-file=./partyb/certificates/truststore.jks
kubectl create secret generic notary-keystore --from-file=./notary/certificates/nodekeystore.jks --from-file=./notary/certificates/sslkeystore.jks --from-file=./notary/certificates/truststore.jks

