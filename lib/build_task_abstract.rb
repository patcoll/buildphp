class BuildTaskAbstract
  @config = {}
  
  class << self
    attr_accessor :prefix
    attr_accessor :flags
    attr_accessor :config
    attr_accessor :filename
    attr_accessor :dir

    def prefix
      "[#{Inflect.underscore(self.to_s)}] "
    end
    
    def flags
      f = []
      
      # Mac Universal Binary flags? TODO: not tested
      # flags = "-O3 -arch i386 -arch x86_64 -arch ppc7400 -arch ppc64"
      
      # enable PIC
      if not `uname -a`.index("x86_64") == nil
        f << "-fPIC"
      end
      # 
      # -fno-common enables PIC on Darwin
      # f << "-fno-common"
      
      f = f.join(' ')
      
      "CFLAGS='#{f}' LDFLAGS='#{f}' CXXFLAGS='#{f}'"
    end
    
    def stop(msg)
      abort prefix + msg
    end

    def notice(msg)
      puts prefix + msg
    end
    
    def get_build_string
      './configure'
    end
    
    def get()
      if not is_installed
        config[:package][:path] = File.join(EXTRACT_TO, config[:package][:name])

        Dir.chdir(EXTRACT_TO)

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
      end
    end # /get
    
    def configure()
      if not is_installed
        stop "extract folder does not exist" if not File.exists?(config[:extract][:dir])
        Dir.chdir(config[:extract][:dir]) do
          sh get_build_string() do |ok,res|
            stop "configure failed" if not ok
          end
        end
      end
    end # /configure
    
    def compile(cmd='make')
      if not is_installed
        Dir.chdir(config[:extract][:dir]) do
          sh cmd do |ok,res|
            stop "build failed" if not ok
          end
        end
      end
    end # /compile
    
    def install(cmd='make install')
      if not is_installed
        Dir.chdir(config[:extract][:dir]) do
          sh cmd do |ok,res|
            stop "install failed" if not ok
            notice "install succeeded!"
          end
        end
      else
        notice "already installed"
      end
    end # /install
  end
end