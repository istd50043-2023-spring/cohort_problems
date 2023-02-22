package com.sutd50043;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Ex5 {

  public static class TokenizerMapper
       extends Mapper<Object, Text, Text, FloatWritable>{

    private FloatWritable price = new FloatWritable();
    private Text sid = new Text();

    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
      StringTokenizer itr = new StringTokenizer(value.toString(), ",");
      String pid = itr.nextToken();
      sid.set(itr.nextToken()); 
      price.set(Float.parseFloat(itr.nextToken()));
      context.write(sid, price);
    }
  }

  public static class FloatAvgReducer
       extends Reducer<Text,FloatWritable,Text,FloatWritable> {
    private FloatWritable result = new FloatWritable();

    public void reduce(Text key, Iterable<FloatWritable> values,
                       Context context
                       ) throws IOException, InterruptedException {
      float sum = 0;
      float count = 0;
      for (FloatWritable val : values) {
        sum += val.get();
        count += 1;
      }
      result.set(sum/count);
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "ex5");
    job.setJarByClass(Ex4.class);
    job.setMapperClass(TokenizerMapper.class);
    // job.setCombinerClass(FloatAvgReducer.class);
    job.setReducerClass(FloatAvgReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(FloatWritable.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
