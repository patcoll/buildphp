class Mcrypt < Package
  PACKAGE_VERSION = '2.5.8'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '2.5.8' => { :md5 => '0821830d930a86a5c69110837c55b7da' },
    }
  end
  
  def package_name
    'libmcrypt-%s.tar.gz' % @version
  end
  
  def package_dir
    'libmcrypt-%s' % @version
  end
  
  def package_location
    'http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/%s/%s' % [@version, package_name]
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-mcrypt=shared,#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libmcrypt.*"].empty?
  end
end
