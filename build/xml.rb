class Xml < BuildTaskAbstract
  VERSION = '2.6.30'
  
  def versions
    {
      '2.6.30' => { :md5 => '460e6d853e824da700d698532e57316b' },
    }
  end
  
  def package_depends_on
    [
      'iconv',
    ]
  end
  
  def package_name
    'libxml2-%s.tar.gz' % @version
  end
  
  def package_dir
    'libxml2-%s' % @version
  end
  
  def package_location
    'ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/%s' % package_name
  end
  
  def get_build_string
    "./configure --prefix=#{INSTALL_TO} --with-iconv=#{INSTALL_TO}"
  end
  
  def php_config_flags
    [
      "--with-libxml-dir=shared,#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'bin', 'xml2-config'))
  end
end
