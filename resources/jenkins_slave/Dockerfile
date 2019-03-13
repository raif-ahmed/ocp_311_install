FROM openshift3/jenkins-slave-maven-rhel7:latest
USER root
RUN yum -y install skopeo && \
    yum clean all
USER 1001
