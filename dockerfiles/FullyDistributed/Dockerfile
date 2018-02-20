FROM ibmjava:8-jre

# 更改时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
	ssh \
	rsync \
	vim \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz \
	&& tar -xf hadoop-2.7.4.tar.gz \
	&& rm -rf hadoop-2.7.4.tar.gz \
	&& echo "export JAVA_HOME="$JAVA_HOME >> hadoop-2.7.4/etc/hadoop/hadoop-env.sh \
	&& ln -s hadoop-2.7.4 hadoop

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys

COPY core-site.xml hadoop/etc/hadoop/
COPY hdfs-site.xml hadoop/etc/hadoop/
COPY mapred-site.xml hadoop/etc/hadoop/
COPY yarn-site.xml hadoop/etc/hadoop/
COPY slaves hadoop/etc/hadoop/

# 添加测试用户root，密码12345678，并且将此用户添加到sudoers里  
RUN echo "root:12345678" | chpasswd  

RUN mkdir /var/run/sshd  
EXPOSE 22  
CMD ["/usr/sbin/sshd", "-D"]
