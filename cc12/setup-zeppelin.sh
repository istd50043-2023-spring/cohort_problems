echo "Downloading Zeppelin..."
cd /tmp/
wget https://downloads.apache.org/zeppelin/zeppelin-0.9.0/zeppelin-0.9.0-bin-all.tgz zeppelin-0.9.0-bin-all.tgz
tar zxvf zeppelin-0.9.0-bin-all.tgz

echo "Configuring Zeppelin..."
echo -e "
export JAVA_HOME=/usr/lib/jvm/adoptopenjdk-8-hotspot
export HADOOP_HOME=/home/ec2-user/hadoop
export SPARK_HOME=/home/ec2-user/spark
export HADOOP_CONF_DIR=\${HADOOP_HOME}/etc/hadoop
export PYSPARK_PYTHON=python3
export MASTER=yarn-client
" >> zeppelin-0.9.0-bin-all/conf/zeppelin-env.sh

cp zeppelin-0.9.0-bin-all/conf/zeppelin-site.xml.template zeppelin-0.9.0-bin-all/conf/zeppelin-site.xml
sed -i  "s/<value>127.0.0.1<\/value>/<value>0.0.0.0<\/value>/g" zeppelin-0.9.0-bin-all/conf/zeppelin-site.xml
sed -i  "s/<value>8080<\/value>/<value>9090<\/value>/g" zeppelin-0.9.0-bin-all/conf/zeppelin-site.xml
sed -i  "s/<value>8443<\/value>/<value>9443<\/value>/g" zeppelin-0.9.0-bin-all/conf/zeppelin-site.xml


mv zeppelin-0.9.0-bin-all /home/ec2-user/
rm zeppelin-0.9.0-bin-all.tgz
cd /home/ec2-user

echo "Done"