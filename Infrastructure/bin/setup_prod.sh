#!/bin/bash
# Setup Production Project (initial active services: Green)
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Setting up Parks Production Environment in project ${GUID}-parks-prod"

# Code to set up the parks production project. It will need a StatefulSet MongoDB, and two applications each (Blue/Green) for NationalParks, MLBParks and Parksmap.
# The Green services/routes need to be active initially to guarantee a successful grading pipeline run.

# To be Implemented by Student

function ocn {
    oc -n $GUID-parks-prod $@
}

ocn create -f Infrastructure/templates/parks-prod/parks-prod-mongodb.yml
ocn policy add-role-to-user admin system:serviceaccount:${GUID}-jenkins:jenkins

ocn create -f Infrastructure/templates/parks-prod/parks-prod-mongo-creds.yml

function establish_bluegreen_apps {

    # Set up Blue Application
    ocn new-app ${GUID}-parks-prod/$1:0.0 --name=$1-blue --allow-missing-images=true 
    ocn set triggers dc/$1-blue --remove-all 
    ocn expose dc $1-blue --port 8080
    oc  -n $GUID-parks-prod create configmap $1-blue-config --from-literal="APPNAME=$2 (Blue)"
    ocn volume dc/$1-blue --add -t=configmap --configmap-name=$1-blue-config --name=$1-blue-mount

    # Set up Green Application
    ocn new-app ${GUID}-parks-prod/$1:0.0 --name=$1-green --allow-missing-images=true 
    ocn set triggers dc/$1-green --remove-all 
    ocn expose dc $1-green --port 8080 
    oc  -n $GUID-parks-prod create configmap $1-green-config --from-literal="APPNAME=$2 (Green)"
    ocn volume dc/$1-green --add -t=configmap --configmap-name=$1-green-config --name=$1-green-mount

    # Expose *green* service first as route so pipeline switches to make blue application active
    ocn expose svc/$1-green --name $1 
}

establish_bluegreen_apps parksmap "ParksMap"
establish_bluegreen_apps nationalparks "National Parks"
establish_bluegreen_apps mlbparks "MLB Parks"