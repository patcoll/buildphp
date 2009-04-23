class Bz2 < BuildTaskAbstract
  @filename = 'bzip2-1.0.5.tar.gz'
  @dir = 'bzip2-1.0.5'
  @config = {
    :package => {
      :dir => dir,
      :name => filename,
      :location => "http://www.bzip.org/1.0.5/#{filename}",
      :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a',
    },
    :extract => {
      :dir => File.join(EXTRACT_TO, dir),
    },
    :php_config_flags => [
      "--with-bz2=shared,#{INSTALL_TO}",
    ],
  }
  class << self
    def is_installed
      File.exists?(File.join(INSTALL_TO, 'include', 'bzlib.h'))
    end
  end
end

namespace :bz2 do
  task :get do
    Bz2.get()
  end
  
  task :compile => ((Bz2.config[:package][:depends_on] || []) + [:get]) do
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
    Bz2.compile(cmd)
  end
  
  task :install => :compile do
    Bz2.install("make install PREFIX=#{INSTALL_TO}")
  end
end
