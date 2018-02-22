# 使用方法

```
docker pull registry.cn-hangzhou.aliyuncs.com/codeboytj/hadoop-fully-distributed
```

## 启动容器

```
docker-compose up -d
```

网段与[固定ip](http://www.jb51.net/article/118396.htm)的东东写在docker-compose.yml中的

## 启动hdfs

在namenode中进行文件系统格式化

```
bin/hdfs namenode -format
```

将namenode中的东西复制到datanode

```
  scp  -rq /usr/local/hadoop   datanode1:/usr/local
  scp  -rq /usr/local/hadoop   datanode2:/usr/local
```

启动hdfs

```
sbin/start-dfs.sh
```

## 启动zookeeper

进入每台服务器的zookepper根目录，运行命令，启动每台机器上的zookeeper

```
bin/zkServer.sh start
```
