#!/bin/sh

# download releases

ONTOP_DIST=ontop-distribution-3.0.0-beta-2

if [[ ! -d ${ONTOP_DIST} ]]; then
    mkdir -p ${ONTOP_DIST}
    curl https://netcologne.dl.sourceforge.net/project/ontop4obda/ontop-3.0.0-beta-2/${ONTOP_DIST}.zip -o "${ONTOP_DIST}.zip"
    unzip "${ONTOP_DIST}.zip" -d "${ONTOP_DIST}"
    rm "${ONTOP_DIST}.zip"
fi

JETTY_BUNDLE=ontop-jetty-bundle-3.0.0-beta-2
if [[ ! -d ${JETTY_BUNDLE} ]]; then
    mkdir -p ${JETTY_BUNDLE}
curl "https://netcologne.dl.sourceforge.net/project/ontop4obda/ontop-3.0.0-beta-2/${JETTY_BUNDLE}.zip" -o "${JETTY_BUNDLE}.zip"
unzip "${JETTY_BUNDLE}.zip" -d "${JETTY_BUNDLE}"
mv ${JETTY_BUNDLE}/jetty-distribution-9.4.6.v20170531/* ${JETTY_BUNDLE} # move content up one level
rm -r "${JETTY_BUNDLE}/jetty-distribution-9.4.6.v20170531"
rm "${JETTY_BUNDLE}.zip"
fi

cd "${ONTOP_DIST}/jdbc"

# download JDBC connectors

#curl http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar -o mysql-connector-java-8.0.12.jar

curl https://jdbc.postgresql.org/download/postgresql-42.2.4.jar -o postgresql-42.2.4.jar

#curl https://download.microsoft.com/download/2/F/C/2FC75210-EDDE-464C-8E54-45C0291032FF/sqljdbc_7.0.0.0_enu.tar.gz -o sqljdbc_7.0.0.0_enu.tar.gz
#tar -xzf sqljdbc_7.0.0.0_enu.tar.gz
#cp sqljdbc_7.0/enu/mssql-jdbc-7.0.0.jre8.jar .
#rm -rf sqljdbc_7.0.0.0_enu.tar.gz sqljdbc_7.0

cd ../..

# build Docker image

docker build -t bjonnh/ontop -t bjonnh/ontop:3.0.0-beta-2 .
