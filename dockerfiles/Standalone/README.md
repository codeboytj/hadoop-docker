# 单机模式使用说明

hadoop默认的就是单机模式，这个模式不需要配置ssh之类的

## 创建镜像

在当前目录下，输入运行命令，创建名为hadoop-standalone，版本号为0.02的镜像：

```
sudo docker build -t hadoop-standalone:0.02 .
```

## 运行容器

创建镜像之后，输入运行命令,运行名为standalone-hadoop的容器：

```
sudo docker run -it --rm --name standalone-hadoop hadoop-standalone:0.02
```

这样会进入到容器之中，默认工作目录为"/usr/local",此时进入hadoop目录，运行hadoop官方文档的例子

```
root@c4ebb472ad6b:/usr/local# cd hadoop-2.7.3/
root@c4ebb472ad6b:/usr/local/hadoop-2.7.3# mkdir input ; \
> cp etc/hadoop/*.xml input ; \
> bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar grep input output 'dfs[a-z.]+' ; \
> cat output/*
```

从输出中可以看出，例子程序运行成功

## 离开容器

使用shell命令离开容器：

```
exit
```

由于运行容器时设置了--rm参数，离开容器之后，容器会被自动删除，再次运行需要重新输入docker run命令运行
