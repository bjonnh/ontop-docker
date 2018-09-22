FROM openjdk:8-jre

LABEL maintainer="martynas@atomgraph.com"

WORKDIR /usr/ontop

COPY ./ontop-distribution-3.0.0-beta-2/jdbc/ jdbc/
COPY ./ontop-distribution-3.0.0-beta-2/lib/ lib/
COPY ./ontop-distribution-3.0.0-beta-2/ontop .

COPY ./ontop-jetty-bundle-3.0.0-beta-2/ jetty/

COPY entrypoint.sh .

ENV ONTOP_JDBC_PROPERTIES=jdbc.properties

ENV ONTOP_JDBC_NAME=
ENV ONTOP_JDBC_URL=
ENV ONTOP_JDBC_USER=
ENV ONTOP_JDBC_PASSWORD=
ENV ONTOP_JDBC_DRIVER=

ENV ONTOP_MAPPING=mapping.obda
ENV ONTOP_ONTOLOGY=ontology.owl
ENV ONTOP_BASE_IRI=

ENV ONTOP_REPOSITORY_ID=
ENV ONTOP_REPOSITORY_TITLE=

VOLUME $ONTOP_MAPPING
VOLUME $ONTOP_ONTOLOGY

# rdf4j-workbench port
EXPOSE 8080

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]