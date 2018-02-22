# 使用方法

```
docker pull registry.cn-hangzhou.aliyuncs.com/codeboytj/hadoop-fully-distributed:hbase
```

## 启动容器

```
docker-compose up -d
```

网段与[固定ip](http://www.jb51.net/article/118396.htm)的东东写在docker-compose.yml中的

## 启动zookeeper

使用`docker exec -it xxxx /bin/bash`登录到各个zookeeper节点，分别打开zookeeper服务

```
./zookeeper/bin/zkServer.sh start
```

## 启动hdfs

在namenode中进行文件系统格式化

```
bin/hdfs namenode -format
```

启动hdfs

```
sbin/start-dfs.sh
```

启动yarn

```
sbin/start-yarn.sh
```

## 启动hbase

进入namenode

```
hbase/bin/start-hbase.sh
```
