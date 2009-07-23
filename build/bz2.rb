class Bz2 < BuildTaskAbstract
  VERSION = '1.0.5'
  
  def versions
    {
      '1.0.5' => { :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a' },
    }
  end
  
  def filename
    'bzip2-%s.tar.gz'
  end
  
  def dir
    'bzip2-%s'
  end
  
  def location
    'http://www.bzip.org/1.0.5/%s'
  end
  
  def php_config_flags
    [
      "--with-bz2=shared,#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'include', 'bzlib.h'))
  end
end

FACTORY.add(Bz2.new(Bz2::VERSION))

namespace :bz2 do
  task :get do
    FACTORY.get('Bz2').get()
  end
  
  task :compile => ((FACTORY.get('Bz2').package_depends_on || []) + [:get]) do
    cmd = "make"
    # bz2 does not detect whether to compile with position-independent code (PIC) or not, so we must decide that.
    # If we detect x86_64-linux as the platform, prepend -fPIC flag to gcc compile options to enable PIC.
    # http://en.wikipedia.org/wiki/Position_independent_code
    # 
    # Ideally, we should detect the platform and use the appropriate PIC flag for that platform.
    # 
    # If we don't do this, while compiling PHP will complain that bz2 was not compiled with PIC.
    if RUBY_PLATFORM == 'x86_64-linux'
      # use GNU sed options because we're on linux
      cmd = "sed -r -i.bak -e 's/^(CFLAGS=)(.+)$/\\1-fPIC \\2/' Makefile && make"
    end
    FACTORY.get('Bz2').compile(cmd)
  end
  
  task :install => :compile do
    FACTORY.get('Bz2').install("make install PREFIX=#{INSTALL_TO}")
  end
  
  task :default => :install
end
