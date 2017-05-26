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

要运行自己编写的WordCount，需要将jar文件以及输入文件放到容器内部，通过-v参数实现

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

## 离开容器

使用shell命令离开容器：

```
exit
```

由于运行容器时设置了--rm参数，离开容器之后，容器会被自动删除，再次运行需要重新输入docker run命令运行
