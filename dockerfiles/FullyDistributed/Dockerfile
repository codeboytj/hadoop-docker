FROM registry.cn-hangzhou.aliyuncs.com/codeboytj/hadoop-fully-distributed:zookeeper

WORKDIR /usr/local
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.6-bin.tar.gz \
	&& tar -xf hbase-1.2.6-bin.tar.gz \
	&& rm -rf hbase-1.2.6-bin.tar.gz \
	&& ln -s hbase-1.2.6 hbase \
	&& echo "export JAVA_HOME="$JAVA_HOME >> hbase/conf/hbase-env.sh

RUN echo "export HBASE_MANAGES_ZK=false" >> hbase/conf/hbase-env.sh

COPY hbase-site.xml hbase/conf/
COPY regionservers hbase/conf/
COPY start.sh ./

EXPOSE 22  
CMD ["/bin/bash", "start.sh"]
