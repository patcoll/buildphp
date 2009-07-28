class Zlib < Package
  PACKAGE_VERSION = '1.2.3'
  # PACKAGE_PREFIX = "/usr"
  
  def versions
    {
      '1.2.3' => { :md5 => 'debc62758716a169df9f62e6ab2bc634' },
    }
  end
  
  def package_name
    'zlib-%s.tar.gz' % @version
  end
  
  def package_dir
    'zlib-%s' % @version
  end
  
  def package_location
    'http://www.zlib.net/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--shared"
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-zlib=shared",
      "--with-zlib-dir=#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libz.*"].empty?
  end
end
