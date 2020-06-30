#!/bin/sh

# If variable not present use default values
: ${CORDA_HOME:=/opt/corda}

export CORDA_HOME JAVA_OPTIONS

cd ${CORDA_HOME}

java -jar ${CORDA_HOME}/corda.jar
