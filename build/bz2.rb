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
    sys = `uname -a`
    if sys.index("x86_64") != nil and sys.downcase.index("linux") != nil
      cmd = "sed -r -i bak -e 's/^(CFLAGS=)(.+)$/\1-fPIC \2/' Makefile; make"
    end
    Bz2.compile(cmd)
    # Bz2.compile()
  end
  
  task :install => :compile do
    Bz2.install("make install PREFIX=#{INSTALL_TO}")
  end
end