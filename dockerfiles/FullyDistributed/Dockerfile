FROM registry.cn-hangzhou.aliyuncs.com/codeboytj/hadoop-fully-distributed:hdfs

WORKDIR /usr/local
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/zookeeper-3.4.10.tar.gz \
	&& tar -xf zookeeper-3.4.10.tar.gz \
	&& rm -rf zookeeper-3.4.10.tar.gz \
	&& ln -s zookeeper-3.4.10 zookeeper

COPY zoo.cfg zookeeper/conf/
COPY zkStart.sh zookeeper/
COPY start.sh ./

RUN chmod 777 ./start.sh

EXPOSE 22  
CMD ["/bin/bash","start.sh"]
