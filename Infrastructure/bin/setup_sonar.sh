#!/bin/bash
# Setup Sonarqube Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Sonarqube in project $GUID-sonarqube"

# Code to set up the SonarQube project.
# Ideally just calls a template
# oc new-app -f ../templates/sonarqube.yaml --param .....

# To be Implemented by Student


# Postgres
oc new-app
    --template=postgresql-persistent \
    --param POSTGRESQL_USER=sonar \
    --param POSTGRESQL_PASSWORD=sonar \
    --param POSTGRESQL_DATABASE=sonar \
    --param VOLUME_CAPACITY=4Gi \
    --labels=app=sonarqube
