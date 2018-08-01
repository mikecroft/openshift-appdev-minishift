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
