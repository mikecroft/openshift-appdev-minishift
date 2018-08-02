#!/bin/bash
# Setup Development Project
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Development Environment in project ${GUID}-parks-dev"
# Code to set up the parks development project.
# To be Implemented by Student

# setup_dev.sh: This script needs to do the following in the $GUID-parks-dev project:

#  ❌  1 Grant the correct permissions to the Jenkins service account
#  ✔  2 Create a MongoDB database
#  ❌  3 Create binary build configurations for the pipelines to use for each microservice
#  ❌  4 Create ConfigMaps for configuration of the applications
#  ❌      4.1 Set APPNAME to the following values—the grading pipeline checks for these exact strings:
#  ❌          4.1.1 MLB Parks (Dev)
#  ❌          4.1.2 National Parks (Dev)
#  ❌          4.1.3 ParksMap (Dev)

#  ❌  5 Set up placeholder deployment configurations for the three microservices
#  ❌  6 Configure the deployment configurations using the ConfigMaps
#  ❌  7 Set deployment hooks to populate the database for the back end services
#  ❌  8 Set up liveness and readiness probes
#  ❌  9 Expose and label the services properly (parksmap-backend)

function ocn {
    oc -n $GUID-parks-dev $@
}

ocn create -f Infrastructure/templates/parks-dev/parks-dev-mongodb.yml

ocn policy add-role-to-user admin system:serviceaccount:${GUID}-jenkins:jenkins 



# Set up parksmap Dev Application
function establish_app {
    ocn new-build redhat-openjdk18-openshift:1.2 --name=$1 --strategy=source --binary

    ocn new-app $GUID-parks-dev/$1:0.0-0 --name=$1 --allow-missing-imagestream-tags=true
    ocn set triggers dc/$1 --remove-all
    ocn expose dc $1 --port 8080
    ocn expose svc $1
    ocn create configmap $1-config --from-literal="APPNAME=$2 (Dev)"
    ocn volume dc/$1 --add -t=configmap --configmap-name=$1-config --name=$1-mount
}

establish_app parksmap ParksMap
establish_app nationalparks "National Parks"
establish_app mlbparks "MLB Parks"