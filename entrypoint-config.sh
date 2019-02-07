#!/usr/bin/env sh

set -e

cd /usr/ontop/jetty/ontop-base

java -jar ../start.jar & # start the Java server in the background so the script can continue
printf "\n### Waiting for Workbench to initialize...\n\n"
sleep 10; # give Workbench some time to start

for config in /configs/*/ ; do
    ID=$(cat ${config}/id)
    TITLE=$(cat ${config}/title)
    printf "\n### Creating repository. ID: ${ID} Title: ${TITLE}\n\n"
    if [[ -f ${config}/mapping.ttl ]]; then
        CONFIGFILE="obdaFile=${config}/mapping.ttl"
    else
        CONFIGFILE="obdaFile=${config}/mapping.obda"
    fi

    curl -s -X POST \
         --data-urlencode ${CONFIGFILE}  \
         --data-urlencode "owlFile=${config}/ontology.owl" \
         --data-urlencode "propertiesFile=${config}/jdbc.properties" \
         --data-urlencode "Repository+ID=${ID}" \
         --data-urlencode "Repository+title=${TITLE}" \
         --data-urlencode "type=ontop-virtual" \
         http://localhost:8080/rdf4j-workbench/repositories/NONE/create
    printf "\n### Repository 'http://localhost:8080/rdf4j-workbench/repositories/${ID}' created. Server ready\n\n"
done

while :; do sleep 1; done # infinite loop
