require 'digest/md5'

class BuildTaskAbstract
  attr_reader :prefix
  attr_reader :flags
  
  # attr_reader :versions
  # attr_reader :filename
  # attr_reader :dir
  # attr_reader :location
  attr_reader :php_config_flags
  
  attr_reader :version
  attr_reader :package_depends_on
  attr_reader :package_dir
  attr_reader :package_name
  attr_reader :package_location
  attr_reader :package_md5
  attr_reader :extract_dir
  attr_reader :extract_cmd
  
  def initialize(version)
    @version = VERSION if VERSION
    @version = version if version
    nil if not @version
    @package_path = File.join(EXTRACT_TO, package_name)
  end
  
  def to_s
    self.class.to_s
  end
  
  def versions
    {}
  end
  
  def package_depends_on
    []
  end
  
  def package_name
    nil
    # filename % @version
  end
  
  def package_dir
    nil
    # dir % @version
  end
  
  def package_location
    nil
    # location % package_name
  end
  
  def package_md5
    versions[@version][:md5]
  end
  
  def php_config_flags
    []
  end
  
  def extract_dir
    nil if not package_dir
    File.join(EXTRACT_TO, package_dir)
  end
  
  def extract_cmd
    "tar xfz %s" % package_name
  end
  
  def is_installed
    false
  end
  
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
    "./configure --prefix=#{INSTALL_TO}"
  end
  
  def get()
    if not is_installed
      Dir.chdir(EXTRACT_TO)

      if File.exists?(@package_path) && package_md5 == Digest::MD5.file(@package_path).hexdigest
        notice "package already downloaded"
      else
        # get
        sh "rm -f #{package_name} && wget #{package_location}"
        # verify
        stop 'MD5 does not match' if package_md5 != Digest::MD5.file(@package_path).hexdigest
      end

      # remove folder if already extracted.
      sh "rm -rf #{extract_dir}" if extract_dir and File.exists?(extract_dir)

      # extract archive
      sh extract_cmd
    end
  end # /get
  
  def configure()
    if not is_installed
      stop "extract folder does not exist" if not File.exists?(extract_dir)
      Dir.chdir(extract_dir) do
        sh get_build_string() do |ok,res|
          stop "configure failed" if not ok
        end
      end
    end
  end # /configure
  
  def compile(cmd='make')
    if not is_installed
      Dir.chdir(extract_dir) do
        sh cmd do |ok,res|
          stop "build failed" if not ok
        end
      end
    end
  end # /compile
  
  def install(cmd='make install')
    if not is_installed
      Dir.chdir(extract_dir) do
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