FROM ubuntu:focal
MAINTAINER Estanislao Pérez Nartallo <tanisperez@gmail.com>

# Jenkins version
ENV JENKINS_VERSION 2.242

# Other env variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

# Java Home
ENV JAVA_HOME /opt/jdk11

# Install git, openjdk8
RUN apt-get update \
  && apt-get install -y --no-install-recommends git wget ttf-dejavu fontconfig ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Get OpenJDK 8
RUN wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09/OpenJDK8U-jdk_aarch64_linux_hotspot_8u252b09.tar.gz --no-check-certificate -O /opt/jdk8.tar.gz
RUN tar -xvf /opt/jdk8.tar.gz -C /opt \
  &&  mv /opt/jdk8u252-b09 /opt/jdk8 \
  &&  rm /opt/jdk8.tar.gz

# Get OpenJDK 11
RUN wget https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.7_10.tar.gz --no-check-certificate -O /opt/jdk11.tar.gz
RUN tar -xvf /opt/jdk11.tar.gz -C /opt \
  && mv /opt/jdk-11.0.7+10 /opt/jdk11 \
  &&  rm /opt/jdk11.tar.gz

# Get MAVEN
RUN wget https://apache.brunneis.com/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz --no-check-certificate -O /opt/maven.tar.gz
RUN tar -xvf /opt/maven.tar.gz -C /opt \
  && mv /opt/apache-maven-3.6.3 /opt/maven \
  && rm /opt/maven.tar.gz

# Get Jenkins
RUN wget -O /opt/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war --no-check-certificate

# Expose volume
VOLUME ${JENKINS_HOME}

# Working dir
WORKDIR ${JENKINS_HOME}

# Expose ports
EXPOSE 8080 ${JENKINS_SLAVE_AGENT_PORT}

# Start Jenkins
CMD ["sh", "-c", "/opt/jdk8/bin/java -jar /opt/jenkins.war"]
