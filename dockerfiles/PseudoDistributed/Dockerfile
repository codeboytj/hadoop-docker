FROM java:8u111-jre

# 虽然hadoop目前的稳定版2.7.2支持java1.7，但是3.0的版本要求java1.8，所以就使用java1.8吧

# 更改时区
# 这是临时更改方法:RUN TZ='Asia/Shanghai'; export TZ
# 运行shell命令，将时区永久设成中国北京时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# hadoop依赖两个软件java与ssh
# 安装ssh
RUN apt-get update && apt-get install -y --no-install-recommends \
		ssh \
		rsync \
		vim \
		net-tools \
&& rm -rf /var/lib/apt/lists/*

# ssh免密登录localhost配置,如果是ubuntu16.04，还要在最后使用ssh-add才能正常使用
RUN ssh-keygen -q -P '' -t rsa -f ~/.ssh/localhost_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

# 下载hadoop2.7.3，基于稳定版2.7.2,并修复了221个bug
WORKDIR /usr/local
# 使用-q启用安静模式下载，不打印下载进度，使用-O指定文件下载位置及文件名
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz && \
    tar -xf hadoop-2.7.4.tar.gz && \
    rm -f hadoop-2.7.4.tar.gz && \
    ln -s hadoop-2.7.4 hadoop
# 修改etc/hadoop/hadoop-env.sh，在最后一行加入正确的JAVA_HOME参数
RUN echo "export JAVA_HOME="$JAVA_HOME >> hadoop/etc/hadoop/hadoop-env.sh

# 伪分布式配置
COPY core-site.xml hadoop-2.7.4/etc/hadoop/
COPY hdfs-site.xml hadoop-2.7.4/etc/hadoop/
COPY mapred-site.xml hadoop-2.7.4/etc/hadoop/
COPY yarn-site.xml hadoop-2.7.4/etc/hadoop/
COPY start.sh hadoop-2.7.4/etc/hadoop/start.sh

WORKDIR /usr/local/hadoop

# 格式化文件系统
RUN bin/hdfs namenode -format

WORKDIR /usr/local

# hbase单击模式安装
# 下载hbase
# 使用-q启用安静模式下载，不打印下载进度，使用-O指定文件下载位置及文件名
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hbase/stable/hbase-1.2.6-bin.tar.gz && \
    tar -xf hbase-1.2.6-bin.tar.gz && \
    rm -f hbase-1.2.6-bin.tar.gz && \
    ln -s hbase-1.2.6 hbase
# 修改conf/hbase-env.sh，在最后一行加入正确的JAVA_HOME参数
RUN echo "export JAVA_HOME="$JAVA_HOME >> hbase/conf/hbase-env.sh
# 修改配置文件conf/hbase-site.xml，指定hbase与zookeeper存储数据的本地文件系统中位置
# 根据配置文件，数据存储在/usr/local/hadoop-data/hbase,/usr/local/hadoop-data/zookeeper
RUN mkdir hadoop-data
COPY hbase-site.xml hbase/conf

# 打开ssh，默认居然是关闭的
# RUN /etc/init.d/ssh restart
# CMD ["/etc/init.d/ssh", "restart"]
