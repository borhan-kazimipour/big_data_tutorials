FROM ubuntu:18.04

# set environment vars
ENV HADOOP_HOME /opt/hadoop
ENV HBASE_HOME /usr/local/Hbase
# https://hbase.apache.org/book.html#hbase.versioning
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root


# install packages
RUN \
  apt-get update && apt-get install -y \
  ssh \
  rsync \
  locate \
  netcat \
  curl \
  python3.7 \
  python3-pip\
  vim \
  openjdk-8-jdk

# install pip, Jupyter, spylon-kernel
RUN pip3 install --upgrade pip && \
  pip3 install jupyter && \
  pip3 install spylon-kernel && \
  python3 -m spylon_kernel install


# download and extract hadoop, set JAVA_HOME in hadoop-env.sh, update path
ENV HADOOP_VERSION 2.7.3
RUN \
  wget  https://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
  tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
  rm -f hadoop-${HADOOP_VERSION}.tar.gz && \
  mv hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
  # cat /opt/hadoop/hadoop-common-project/hadoop-common/src/main/conf/hadoop-env.sh && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
  # echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/hadoop-common-project/hadoop-common/src/main/conf/hadoop-env.sh
ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

ENV HBASE_VERSION 1.2.4
RUN \
  wget  https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz && \
  tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz && \
  rm -f hbase-${HBASE_VERSION}-bin.tar.gz && \
  mv hbase-${HBASE_VERSION} $HBASE_HOME && \
  echo "export JAVA_HOME=$JAVA_HOME" >> $HBASE_HOME/conf/hbase-env.sh
ENV PATH $HBASE_HOME/bin:$PATH


# SCALA and SBT
ENV SCALA_VERSION 2.12.8
ENV SBT_VERSION 1.2.8

## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc
ENV PATH ~/scala-$SCALA_VERSION/bin:$PATH

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion && \
  mkdir project && \
  echo "scalaVersion := \"${SCALA_VERSION}\"" > build.sbt && \
  echo "sbt.version=${SBT_VERSION}" > project/build.properties && \
  echo "case object Temp" > Temp.scala && \
  sbt compile && \
  rm -r project && rm build.sbt && rm Temp.scala && rm -r target


# SPARK
ENV SPARK_VERSION 2.4.5
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -sL --retry 3 \
  "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

# install Almond Scala kernel
ENV ALMOND_VERSION=0.9.1
RUN curl -sLo /usr/local/bin/coursier https://github.com/coursier/coursier/releases/download/v2.0.0-RC3-2/coursier && \
    chmod +x /usr/local/bin/coursier && \
    /usr/local/bin/coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_${SCALA_VERSION}:${ALMOND_VERSION} \
      sh.almond:scala-kernel_${SCALA_VERSION}:${ALMOND_VERSION} \
      -o /usr/local/bin/almond && \
    /usr/local/bin/almond --install && \
    rm -f /usr/local/bin/almond

# update PATH in .bashrc
RUN echo "export PATH=$PATH" >> /root/.bashrc

# create ssh keys
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

# copy hadoop configs
ADD configs/*xml $HADOOP_HOME/etc/hadoop/

# copy hbase configs
ADD configs/hbase-site.xml $HBASE_HOME/conf

# copy ssh config
ADD configs/ssh_config /root/.ssh/config

# expose various ports
EXPOSE 8088 8030 50070 50075 50030 50060 8888 9000 9999

# start hadoop
CMD  bash /home/start-hadoop-hbase-jupyter.sh