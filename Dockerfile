FROM centos:6.8
MAINTAINER Loren <xxxxx>
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
#RUN mkdir -p "$CATALINA_HOME"

WORKDIR $CATALINA_HOME

RUN yum update -y && yum clean all \
    && yum install -y epel-release \
    && yum install -y libapr1 unzip vim \
    && yum clean all
#RUN yum install -y openssh-server

# Install jdk
COPY soft/jdk1.6.0_45.zip /data/soft/
RUN cd /data/soft/ && unzip jdk1.6.0_45.zip -d /usr/local

# Install Tomcat
ADD soft/apache-tomcat-6.0.43.tar.gz /data/soft/
#RUN mv /data/soft/apache-tomcat-6.0.43/* /usr/local/tomcat/ && rm -rf /usr/local/tomcat/webapps/* && rm -rf /data
RUN mv /data/soft/apache-tomcat-6.0.43/* /usr/local/tomcat/ && rm -rf /data

EXPOSE 8080

CMD ["catalina.sh", "run"]
