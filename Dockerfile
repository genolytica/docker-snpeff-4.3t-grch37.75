# Dockerfile

FROM  phusion/baseimage:0.9.17

MAINTAINER  Panagiotis Moulos <pmoulos@hybridstat.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" \
    > /etc/apt/sources.list

RUN apt-get -y update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    libxext-dev libxrender-dev libxtst-dev wget zip unzip \
    python-software-properties software-properties-common

# Install OpenJDK-8
RUN add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> ~/.bashrc

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install snpEff
WORKDIR /opt

RUN wget https://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip
RUN unzip snpEff_latest_core.zip && rm -r snpEff_latest_core.zip clinEff

WORKDIR /opt/snpEff

RUN java -jar snpEff.jar download GRCh37.75 -v
#RUN java -jar snpEff.jar download GRCh38.86 -v

ENTRYPOINT ["java","-Xmx4096m","-jar","/opt/snpEff/snpEff.jar"]

## Usage example
# docker run -ti --rm \
# -v /my/full/local/vcf/path:/path/in/container \
# hybridstat/snpeff:4.3t \
# ann -v -t -noLog -noStats GRCh37.75 /path/in/container/my.vcf
