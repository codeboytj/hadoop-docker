# 单机模式使用说明

hadoop默认的就是单机模式，这个模式不需要配置ssh之类的

## 创建镜像

在当前目录下，输入运行命令，创建名为hadoop-standalone，版本号为0.02的镜像：

```
sudo docker build -t hadoop-standalone:0.02 .
```

## 测试运行容器

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

## 运行自己编写的WordCount

1. 编译并生成jar文件
2. 运行容器
3. 利用hadoop运行WordCount

### 运行容器

要运行自己编写的[WordCount](https://github.com/codeboytj/hadoop-mapreduce-learn/blob/master/src/main/java/cumt/tj/learn/WordCount.java)，需要将jar文件以及输入文件放到容器内部，通过-v参数实现

```
sudo docker run -it --rm -v /home/sky/IdeaProjects/hadoop-mapreduce-learn/inputs:/usr/local/hadoop-2.7.3/inputs -v /home/sky/IdeaProjects/hadoop-mapreduce-learn/build/libs/hadoop-mapreduce-1.0-SNAPSHOT.jar:/usr/local/hadoop-2.7.3/wc.jar --name standalone-hadoop 768
```

其中，各项的含义如下：

- -v /home/sky/IdeaProjects/hadoop-mapreduce-learn/inputs:/usr/local/hadoop-2.7.3/inputs  将IDE中写好的输入文件夹映射到容器中的/usr/local/hadoop-2.7.3/inputs，以便处理
- -v /home/sky/IdeaProjects/hadoop-mapreduce-learn/build/libs/hadoop-mapreduce-1.0-SNAPSHOT.jar:/usr/local/hadoop-2.7.3/wc.jar  将IDE生成的jar文件映射到容器中的/usr/local/hadoop-2.7.3/文件夹，并重命名为wc.jar
- 768 镜像文件的id

### 利用hadoop运行WordCount

```
cd hadoop-2.7.3
bin/hadoop jar wc.jar cumt/tj/learn/WordCount ./inputs/wordCountInput/testWordCount.txt outputs/wordCount/
```

运行命令需要指定执行的类为cumt.tj.learn.WordCount，结果输出到outputs/wordCount/。运行成功后，可以使用cat命令查看输出结果

## hbase相关操作

### 运行容器

```
sudo docker run -it --rm -v /home/sky/hadoop-data:/usr/local/hadoop-data --name standalone-hadoop -p 16010:16010 registry.cn-hangzhou.aliyuncs.com/codeboytj/hadoop-standalone:0.2
```

其中，各项的含义如下：
- -v /home/sky/hadoop-data:/usr/local/hadoop-data 容器内hbase的配置文件hbase-site.xml指定了hbase以及zookeeper的写入文件夹为/usr/local/hadoop-data下面的hbase和zookeeper文件夹
- -p 16010:16010，容器内16010端口映射到本机的16010，这样就可以在容器内的hbase启动之后，通过浏览器打开“http://localhost:16010”查看hbase的状态

### hbase shell命令操作

这样就可以在容器内运行[hbase简单命令](http://hbase.apache.org/book.html#quickstart)

### hbase与mapreduce

#### 运行内置的RowCounter

运行HBase内置的RowCounter，它通过mapreduce计算刚刚使用hbase shell命令创建的名为test的表有多少行

```
HADOOP_CLASSPATH=`/usr/local/hbase-1.2.5/bin/hbase classpath` ./hadoop-2.7.3/bin/hadoop jar ./hbase-1.2.5/lib/hbase-server-1.2.5.jar rowcounter test
```
这行命令中：

- HADOOP_CLASSPATH=`/usr/local/hbase-1.2.5/bin/hbase classpath`，通过``运行shell子命令<br>
```/usr/local/hbase-1.2.5/bin/hbase classpath```将shell命令中的输出指定为HADOOP_CLASSPATH，从而指定mapreduce程序RowCounter的HBase依赖

运行完毕后，可以在控制台看到结果显示，test表中有3行

#### 运行自己编写的[RowCount](https://github.com/codeboytj/hadoop-mapreduce-learn/blob/master/src/main/java/cumt/tj/learn/hbase/RowCounter.java)

1. 导入自己的jar包
2. 运行容器中的hbase，并建立test表
3. 运行mapreduce程序

##### 导入jar包

要运行自己编写的RowCount，需要将自己的程序打包，然后通过"-v"参数映射到容器中，所以需要以如下的命令运行：


```
sudo docker run -it --rm -v /home/sky/IdeaProjects/hadoop-mapreduce-learn/build/libs/hadoop-mapreduce-1.0-SNAPSHOT.jar:/usr/local/hadoop-2.7.3/rc.jar -v /home/sky/hadoop-data:/usr/local/hadoop-data -p 16010:16010 --name standalone-hadoop 66b
```

##### 运行mapreduce程序

```
HADOOP_CLASSPATH=`/usr/local/hbase-1.2.5/bin/hbase classpath` ./hadoop-2.7.3/bin/hadoop jar ./hadoop-2.7.3/rc.jar cumt.tj.learn.hbase.RowCounter test
```

工作结束之后，可以看到test表中的行数为3

## 离开容器

使用shell命令离开容器：

```
exit
```

由于运行容器时设置了--rm参数，离开容器之后，容器会被自动删除，再次运行需要重新输入docker run命令运行
