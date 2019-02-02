#!/bin/sh
set -e

if [[ -z "$ONTOP_JDBC_NAME" ]] ; then
    echo '$ONTOP_JDBC_NAME not set'
    exit 1
fi

if [[ -z "$ONTOP_JDBC_URL" ]] ; then
    echo '$ONTOP_JDBC_URL not set'
    exit 1
fi

if [[ -z "$ONTOP_JDBC_USER" ]] ; then
    echo '$ONTOP_JDBC_USER not set'
    exit 1
fi

if [[ -z "$ONTOP_JDBC_PASSWORD" ]] ; then
    echo '$ONTOP_JDBC_PASSWORD not set'
    exit 1
fi

if [[ -z "$ONTOP_JDBC_DRIVER" ]] ; then
    echo '$ONTOP_JDBC_DRIVER not set'
    exit 1
fi

if [[ -z "$ONTOP_JDBC_PROPERTIES" ]] ; then
    echo '$ONTOP_JDBC_PROPERTIES not set'
    exit 1
fi

if [[ -z "$ONTOP_MAPPING" ]] ; then
    echo '$ONTOP_MAPPING not set'
    exit 1
fi

if [[ -z "$ONTOP_ONTOLOGY" ]] ; then
    echo '$ONTOP_ONTOLOGY not set'
    exit 1
fi

if [[ -z "$ONTOP_BASE_IRI" ]] ; then
    echo '$ONTOP_BASE_IRI not set'
    exit 1
fi

if [[ -z "$ONTOP_REPOSITORY_ID" ]] ; then
    echo '$ONTOP_REPOSITORY_ID not set'
    exit 1
fi

if [[ -z "$ONTOP_REPOSITORY_TITLE" ]] ; then
    echo '$ONTOP_REPOSITORY_TITLE not set'
    exit 1
fi

rm -f ${ONTOP_JDBC_PROPERTIES}

echo "jdbc.name = $ONTOP_JDBC_NAME" >> ${ONTOP_JDBC_PROPERTIES}
echo "jdbc.url = $ONTOP_JDBC_URL" >> ${ONTOP_JDBC_PROPERTIES}
echo "jdbc.user = $ONTOP_JDBC_USER" >> ${ONTOP_JDBC_PROPERTIES}
echo "jdbc.password = $ONTOP_JDBC_PASSWORD" >> ${ONTOP_JDBC_PROPERTIES}
echo "jdbc.driver = $ONTOP_JDBC_DRIVER" >> ${ONTOP_JDBC_PROPERTIES}

# cat $ONTOP_JDBC_PROPERTIES

# bootstrap the default mapping
# https://github.com/ontop/ontop/wiki/OntopCLI#ontop-bootstrap

printf "\n### Bootstrapping ontop mapping\n\n"
./ontop bootstrap -p ${ONTOP_JDBC_PROPERTIES} -m ${ONTOP_MAPPING} -t ${ONTOP_ONTOLOGY} -b ${ONTOP_BASE_IRI}

# cat $ONTOP_MAPPING
# cat $ONTOP_ONTOLOGY

# install RDF4J Workbench
# https://github.com/ontop/ontop/wiki/RDF4J-SPARQL-endpoint-installation

export ONTOP_HOME=/usr/ontop
export JETTY_HOME="${ONTOP_HOME}/jetty"

# copy the JDBC drivers to Workbench
# https://github.com/ontop/ontop/issues/246
cp ${ONTOP_HOME}/jdbc/* ${JETTY_HOME}/lib/ext

cd jetty
cd ontop-base

# run RDF4J Workbench
printf "\n### Starting RDF4J Workbench\n\n"
nohup java -jar ../start.jar & # start the Java server in the background so the script can continue

# create a Virtual RDF Repository
# https://github.com/ontop/ontop/wiki/ObdalibQuestSesameVirtualWB

printf "\n### Waiting for Workbench to initialize...\n\n"
sleep 10; # give Workbench some time to start

printf "\n### Creating repository. ID: ${ONTOP_REPOSITORY_ID} Title: ${ONTOP_REPOSITORY_TITLE}\n\n"

curl -s -X POST \
    --data-urlencode "obdaFile=${ONTOP_HOME}/mapping.obda"  \
    --data-urlencode "owlFile=${ONTOP_HOME}/ontology.owl" \
    --data-urlencode "propertiesFile=${ONTOP_HOME}/jdbc.properties" \
    --data-urlencode "Repository+ID=${ONTOP_REPOSITORY_ID}" \
    --data-urlencode "Repository+title=${ONTOP_REPOSITORY_TITLE}" \
    --data-urlencode "type=ontop-virtual" \
    http://localhost:8080/rdf4j-workbench/repositories/NONE/create

printf "\n### Repository 'http://localhost:8080/rdf4j-workbench/repositories/${ONTOP_REPOSITORY_ID}' created. Server ready\n\n"

while :; do sleep 1; done # infinite loop