FROM openjdk:11-jre

LABEL maintainer="bjo@uic.edu"
ARG ONTOP_VERSION=3.0.0-beta-2

WORKDIR /usr/ontop

RUN curl https://netcologne.dl.sourceforge.net/project/ontop4obda/ontop-$ONTOP_VERSION/ontop-distribution-$ONTOP_VERSION.zip -o /ontop.zip
RUN curl https://netcologne.dl.sourceforge.net/project/ontop4obda/ontop-$ONTOP_VERSION/ontop-jetty-bundle-$ONTOP_VERSION.zip -o /ontop-jetty-bundle.zip
RUN unzip /ontop.zip -d /ontop-distribution-$ONTOP_VERSION
RUN unzip /ontop-jetty-bundle.zip -d /ontop-jetty-bundle-$ONTOP_VERSION
RUN mkdir -p /usr/ontop/jetty
RUN mv /ontop-jetty-bundle-$ONTOP_VERSION/jetty-distribution*/* /usr/ontop/jetty
RUN mv /ontop-distribution-$ONTOP_VERSION/lib /usr/ontop
RUN mv /ontop-distribution-$ONTOP_VERSION/jdbc /usr/ontop/lib/ext
RUN mv /ontop-distribution-$ONTOP_VERSION/ontop /usr/ontop/ontop
RUN curl https://jdbc.postgresql.org/download/postgresql-42.2.5.jar -o /usr/ontop/jetty/lib/ext/postgresql-42.2.5.jar
RUN ln -s /usr/ontop/jetty/lib/ext/postgresql-42.2.5.jar /usr/ontop/lib  # Should be in ext, but not added in the script
RUN mkdir /configs

COPY entrypoint-config.sh .
ENV PATH="/usr/ontop/:${PATH}"
# rdf4j-workbench port
EXPOSE 8080

CMD ["/bin/sh", "entrypoint-config.sh"]
