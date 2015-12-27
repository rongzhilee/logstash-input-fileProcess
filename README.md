测试用的 logstash file导入插件

写这个的目的是由于logstash的input-file是实时导入，对历史导入支持不好。这个插件的逻辑是不停扫描目录下的特定文件导入，并将导入后的文件改名，方便其他程序处理(比如定期删除)

<pre>
fileProcess {
        path =>  "/home/lirongzhi/test/"
        extName => ".txt"
        type => "cdr"
        
        codec => plain {
                charset => "ISO-8859-1"
        }
}
</pre>

<pre>
windows 下打包方法：
1.下载 jruby并安装
https://s3.amazonaws.com/jruby.org/downloads/1.7.22/jruby_windows_x64_1_7_22.exe
2.切换到logstash-input-fileProcess 目录
gem build logstash-input-fileProcess.gemspec
得到
logstash-input-fileProcess-0.1.0.gem
3.上传gem到服务器目录
 logstash-2.1.0/bin/plugin install /path/logstash-input-fileProcess-0.1.0.gem 
 

</pre>