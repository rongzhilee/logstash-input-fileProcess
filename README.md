测试用的 logstash file导入插件

写这个的目的是由胡logstash的input-file是事实导入，而这个是批量导入，并将导入后的文件改名，方便其他程序处理(比如定期删除)

fileProcess {
        path =>  "/home/lirongzhi/test/"
        extName => ".txt"
        type => "cdr"
        
        codec => plain {
                charset => "ISO-8859-1"
        }
}
