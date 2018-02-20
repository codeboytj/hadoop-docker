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
RUN wget -q https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz
	&& tar -xf hadoop-2.7.4.tar.gz
	&& rm -rf hadoop-2.7.4.tar.gz
	&& echo "export JAVA_HOME="$JAVA_HOME >> hadoop-2.7.4/etc/hadoop/hadoop-env.sh
	&& ln -s hadoop-2.7.4 hadoop
