---
author: ISTD, SUTD
title: Lab 11 Spark
date: Feb 22, 2023
logo: 
footnote:
header-includes: |
 \usepackage{tikz}
 \usetikzlibrary{positioning}
 \usetikzlibrary{arrows}
 \usetikzlibrary{shapes.multipart}
---



# Learning outcome


By the end of this lesson, you are able to

* Submit PySpark jobs to a Spark cluster
* Paralelize data processing using PySpark 

# Submit a PySpark job to a Spark cluster 

1. Using FlintRock, launch a Hadoop-Spark cluster with 4 nodes (1 name node and 3 worker/data nodes). For the ease of subsequence exercise, make sure you are a t2.medium instance instead of t2.micro. If you want to stick to t2.micro, you should at least enable swap on the nodes. (For details, refer to lab10). 

2. On the Spark cluster master node, check out the following github repo.

```bash
$ cd
$ mkdir git
$ cd git
$ git clone https://github.com/istd50043-2023-spring/cohort_problems/
```

if it exists, update

```bash
$ cd git
$ git pull
```

3. Change to the `istd50043-2023-spring/cohort_problems/` directory


3. Copy some data into HDFS `/input/` if it is empty, we re-use the data from cc10.

```bash
$ hdfs dfs -mkdir /input/
$ hdfs dfs -rm -r /output
$ hdfs dfs -put ~/git/istd50043-2023-spring/cohort_problems/cc10/data/TheCompleteSherlockHolmes.txt /input/
```


5. Edit the PySpark source code in `cc11/wordcount.py` so that it uses the correct HDFS address.


6. Start the job


If you have turned on Yarn.

```bash
$ spark-submit --master yarn cc11/wordcount.py 
```

Otherwise 

```bash
$ spark-submit --master spark://<internal-ip-of-spark-master>:7077 cc11/wordcount.py  
```


7. Check the output

```bash
$ hdfs dfs -cat /output/*
```


# Exercise 1

Write a PySpark application which takes a (set of) Comma-seperated-value (CSV) file(s) with 2 columns and output a CSV file with first two columns same as the input file, and the third column captures the values obtained by splitting the first column by using the second column as delimiter.

For example, given input from a HDFS file

```
50000.0#0#0#,#
0@1000.0@,@
1$,$
1000.00^Test_string,^
```


the program should output

```
50000.0#0#0#,#,[u'50000.0', u'0', u'0']
0@1000.0@,@,[u'0', u'1000.0', u'']
1$,$,[u'1', u'']
1000.00^Test_string,^,[u'1000.00', u'Test_string']
```

back to the HDFS

# Exercise 2 


Write PySpark application which aggregates a (set of) CSV file(s) with 4 columns based on its third column, (the destination IP). 

Given input

```
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604900, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604899, 10.0.0.2.54880, 10.0.0.3.5001, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
05:49:56.604908, 10.0.0.3.5001, 10.0.0.2.54880, 2
```
the program should output

```
 10.0.0.3.5001,13
 10.0.0.2.54880,7
```


# Exercise 3

Given the same input as the Exercise 2, write a PySpark application which outputs the following

```
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604900,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604899,10.0.0.2.54880, 10.0.0.3.5001, 2, 13
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
05:49:56.604908, 10.0.0.3.5001,10.0.0.2.54880, 2, 7
```


In the event the input is very huge with too many unique destination IP values, can your program scale?


The questions were adopted from 

```url
https://jaceklaskowski.github.io/spark-workshop/exercises/
```
