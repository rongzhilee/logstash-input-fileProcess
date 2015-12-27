# encoding: utf-8
#require "logstash/inputs/base"
#require "logstash/namespace"
#require "stud/interval"
require "socket" # for Socket.gethostname

#require "java"

# Generate a repeating message.
#
# This plugin is intented only as an example.


#class FileProcess
class LogStash::Inputs::FileProcess  < LogStash::Inputs::Base
  config_name "fileProcess"

  # If undefined, Logstash will complain, even if codec is unused.
  default :codec, "plain"

  config :path, :validate => :string, :required => true

  config :extName, :validate => :string, :default => ".txt"
  config :processingExtName, :validate => :string, :default => ".processing"
  config :successExtName, :validate => :string, :default => ".success"
  config :errorExtName, :validate => :string, :default => ".error"
  config :sleepSeconds, :validate => :number, :default => 5
  config :interval, :validate => :number, :default => 1
  
  #def initialize  
    #@path = "C:/test"
    #@extName = ".txt"
    #@processingExtName =  ".processing"
    #@successExtName = ".success"
    #@errorExtName = ".error"
    #@sleepSeconds = 5
  #end

  public
  def register
    #@host = Socket.gethostname.force_encoding(Encoding::UTF_8)
    puts "Registering file input #{@path}"
    puts toStr()
  end # def register

  def run(queue)
    # we can abort the loop if stop? becomes true
    while true
      paths =  findPaths(@path,@extName)
      for path in paths
        processingPath = path + @processingExtName
        puts "processingPath #{processingPath}"
        File.rename(path,processingPath)
        file = File.open(processingPath)
        line = ""
        begin
          while line = file.gets
            line = line.force_encoding("ISO-8859-1")
            event = LogStash::Event.new("message" => line) #, "host" => @host
            decorate(event)
            queue << event
          end
          file.close
          File.rename(processingPath,path+@successExtName)
        rescue => err  
          puts err
          puts "file #{path} is error."
          puts "line is #{line}"
          file.close
          File.rename(processingPath,path+@errorExtName)
        end
      end

      forSleep(paths)
    end # loop
  end # def run

  def stop
    # nothing to do in this case so it is not necessary to define stop
    # examples of common "stop" tasks:
    #  * close sockets (unblocking blocking reads/accepts)
    #  * cleanup temporary files
    #  * terminate spawned threads
  end

  def toStr()
    return    "FileProcess [rootPath=#{ @rootPath}, extName=#{ @extName},
    processingExtName=#{ @processingExtName},
    successExtName=#{ @successExtName}, errorExtName=#{@errorExtName}]";
  end

  def forSleep(paths)
    if paths.size   == 0
      puts "No files found . To Sleep #{@sleepSeconds} seconds";
      sleep @sleepSeconds
    else
      puts "Found files: #{paths.size}. Ready to process. ";
    end
  end

  def findPaths(path,extName)
    result = Array.new
    if File.directory?(path)
      dir = Dir.open(path)
      begin
        dir.each do |file|
          if file != "." && file !=".."
            newPath =  path+"/"+file
            result = result + findPaths(newPath, extName)
          end
        end
      rescue
        puts "file #{path} is error."
      ensure
        dir.close
      end
    else
      if File.extname(path) == extName
        result << path
      end
    end
    return result
  end

end # class LogStash::Inputs::Example
