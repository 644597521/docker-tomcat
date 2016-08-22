FROM centos:6.8
MAINTAINER Loren <xxx@test.com>
LABEL DATE='2016-07-26 15:25'

# TimeZone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# JAVA
ENV JAVA_HOME /usr/local/jdk1.6.0_45
ENV JRE_HOME /usr/local/jdk1.6.0_45/jre
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib

# Tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN yum update -y && yum clean all \
    && yum install -y epel-release \
    && yum install -y libapr1 unzip vim wget\
    && yum clean all
#RUN yum install -y openssh-server

# Install jdk
COPY soft/jdk1.6.0_45.zip /data/soft/
RUN cd /data/soft/ \
    && unzip jdk1.6.0_45.zip -d /usr/local \
    && sed -i '/Djava.security/s/#   //g' /usr/local/jdk1.6.0_45/jre/lib/security/java.security \
    && sed -i '/Djava.security/s/dev\/urandom/dev\/.\/urandom/g' /usr/local/jdk1.6.0_45/jre/lib/security/java.security

# Install Tomcat
ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.43
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
RUN wget -P /data "$TOMCAT_TGZ_URL" \
    && cd /data \
    && tar zxf /data/apache-tomcat-"$TOMCAT_VERSION".tar.gz -C /usr/local \
    && mv /usr/local/apache-tomcat-"$TOMCAT_VERSION" /usr/local/tomcat \
    && rm -rf /data

WORKDIR $CATALINA_HOME

EXPOSE 8080

CMD ["catalina.sh", "run"]
