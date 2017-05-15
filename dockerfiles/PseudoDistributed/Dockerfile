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
&& rm -rf /var/lib/apt/lists/*
# 配置ssh,貌似单击模式不需要配置ssh免密登录

# 下载hadoop2.7.3，基于稳定版2.7.2,并修复了221个bug
WORKDIR /usr/local
# 使用-q启用安静模式下载，不打印下载进度，使用-O指定文件下载位置及文件名
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
# 解压hadoop
RUN tar -xf hadoop-2.7.3.tar.gz
# 删除压缩包
RUN rm hadoop-2.7.3.tar.gz
# 修改etc/hadoop/hadoop-env.sh，在最后一行加入正确的JAVA_HOME参数
RUN echo "export="$JAVA_HOME >> hadoop-2.7.3/etc/hadoop/hadoop-env.sh

# 伪分布式配置
COPY core-site.xml hadoop-2.7.3/etc/hadoop/
COPY hdfs-site.xml hadoop-2.7.3/etc/hadoop/

# 切换工作目录到/usr/local/hadoop-2.7.3
WORKDIR /usr/local/hadoop-2.7.3

# 格式化文件系统
RUN bin/hdfs namenode -format

# ssh免密登录localhost配置,如果是ubuntu16.04，还要在最后使用ssh-add才能正常使用
RUN ssh-keygen -q -P '' -t rsa -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
# 打开ssh，默认居然是关闭的
# RUN /etc/init.d/ssh restart
