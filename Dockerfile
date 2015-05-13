FROM muzili/centos-base
MAINTAINER Joshua Lee <muzili@gmail.com>

# UPDATE
RUN yum -q -y update && \
    yum -q -y install wget tar java-1.7.0-openjdk && \
    yum -q -y install ctags


RUN wget 'https://socrata-oss.ci.cloudbees.com/job/opendj/lastSuccessfulBuild/org.forgerock.opendj$opendj-server/artifact/org.forgerock.opendj/opendj-server/2.6.0/opendj-server-2.6.0.zip' -O /opt/opendj-server.zip && \
    unzip /opt/opendj-server.zip -d /opt

ENV LDAP_BASE_DN dc=example,dc=com
ENV LDAP_ROOT_DN cn=admin
ENV LDAP_ROOT_PASS passpass

EXPOSE 389 636 4444

# Create the sleleton 1st run
ADD scripts /scripts
RUN chmod +x /scripts/start.sh && touch /first_run

# Kicking in
CMD ["/scripts/start.sh"]
