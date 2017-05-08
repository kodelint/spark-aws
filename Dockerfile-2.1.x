FROM openjdk:8u121-jre-alpine
MAINTAINER Luis Angel Vicente Sanchez "luis@bigcente.ch"

RUN apk add --no-cache bash coreutils procps python wget \
 && rm -rf /var/cache/apk/*

ENV AMAZON_SDK_VERSION=1.7.4
ENV HADOOP_AWS_VERSION=2.7.3
ENV HADOOP_VERSION=2.7
ENV SPARK_VERSION=2.1.1

RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -P /tmp \
 && wget http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/${AMAZON_SDK_VERSION}/aws-java-sdk-${AMAZON_SDK_VERSION}.jar -P /tmp \ 
 && wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar -P /tmp \ 
 && tar -xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local/ \
 && chown -R root:root /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} \
 && ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /usr/local/spark \
 && cp /tmp/aws-java-sdk-${AMAZON_SDK_VERSION}.jar /usr/local/spark/jars/ \
 && cp /tmp/hadoop-aws-${HADOOP_AWS_VERSION}.jar /usr/local/spark/jars/ \
 && rm -f /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && rm /tmp/aws-java-sdk-${AMAZON_SDK_VERSION}.jar \ 
 && rm /tmp/hadoop-aws-${HADOOP_AWS_VERSION}.jar 

ADD log4j.properties /usr/local/spark/conf/log4j.properties
ADD spark-defaults.conf /usr/local/spark/conf/spark-defaults.conf
ADD spark-env.sh /usr/local/spark/conf/spark-env.sh
ENV PATH $PATH:/usr/local/spark/bin
ENV SPARK_HOME /usr/local/spark
WORKDIR /usr/local/spark
