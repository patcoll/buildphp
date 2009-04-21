class BuildTaskAbstract
  @prefix = '[...] '
  @config = {}
  
  class << self
    attr_accessor :prefix
    attr_accessor :config

    def stop(msg)
      abort prefix + msg
    end

    def notice(msg)
      puts prefix + msg
    end
    
    def get_build_string
      './configure'
    end
    
    def get(task)
      config[:package][:path] = File.join(ENV['BUILDPHP_EXTRACT_TO'], config[:package][:name])

      Dir.chdir(ENV['BUILDPHP_EXTRACT_TO'])

      if File.exists?(config[:package][:path]) && config[:package][:md5] == Digest::MD5.file(config[:package][:path]).hexdigest
        notice "package already downloaded"
      else
        # get
        sh "rm -f #{config[:package][:name]} && wget #{config[:package][:location]}"
        # verify
        stop 'MD5 does not match' if config[:package][:md5] != Digest::MD5.file(config[:package][:path]).hexdigest
      end

      # remove folder if already extracted.
      sh "rm -rf #{config[:extract][:dir]}" if File.exists?(config[:extract][:dir])

      # extract archive
      sh "tar xfz #{config[:package][:path]}"
    end # /get
    
    def configure(task)
      stop "extract folder does not exist" if not File.exists?(config[:extract][:dir])
      Dir.chdir(config[:extract][:dir]) do
        sh get_build_string() do |ok,res|
          stop "configure failed" if not ok
        end
      end
    end # /configure
    
    def compile(task)
      Dir.chdir(config[:extract][:dir]) do
        sh "make" do |ok,res|
          stop "build failed" if not ok
        end
      end
    end # /compile
    
    def install(task)
      if not is_installed
        Dir.chdir(config[:extract][:dir]) do
          sh "make install" do |ok,res|
            stop "install failed" if not ok
            notice "install succeeded!"
          end
        end
      end
    end # /install
  end
end