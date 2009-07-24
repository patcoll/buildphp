class Zlib < BuildTaskAbstract
  VERSION = '1.2.3'
  
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
  
  def php_config_flags
    [
      "--with-zlib=shared",
      "--with-zlib-dir=#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'include', 'zlib.h'))
  end
end
