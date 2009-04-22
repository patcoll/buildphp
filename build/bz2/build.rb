class Bz2 < BuildTaskAbstract
  @prefix = '[bz2] '
  @config = {
    :package => {
      :depends_on => [], # empty array for none.
      :dir => 'bzip2-1.0.5',
      :name => 'bzip2-1.0.5.tar.gz',
      :location => 'http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz',
      :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a'
    },
    :extract => {
      :dir => File.join(Dir.pwd, 'packages', 'bzip2-1.0.5')
    }
  }
  class << self
    def get_build_string
      parts = %w{ ./configure }
      parts << "--prefix=#{install_dir}"
      parts.join(' ')
    end # /get_build_string
    def is_installed
      File.exists?(File.join(BuildTaskAbstract.install_dir, 'include', 'bzlib.h'))
    end
  end
end

namespace :bz2 do
  task :get do
    Bz2.get()
  end
  
  task :compile => :get do
    Bz2.compile()
  end
  
  task :install => :compile do
    Bz2.install("make install PREFIX=#{Bz2.install_dir}")
  end
end