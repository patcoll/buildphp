class Xsl < BuildTaskAbstract
  PACKAGE_VERSION = '1.1.22'
  
  def versions
    {
      '1.1.22' => { :md5 => 'd6a9a020a76a3db17848d769d6c9c8a9' },
    }
  end
  
  def package_depends_on
    [
      'xml',
    ]
  end
  
  def package_name
    'libxslt-%s.tar.gz' % @version
  end
  
  def package_dir
    'libxslt-%s' % @version
  end
  
  def package_location
    'ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{INSTALL_TO}"
    parts << "--with-libxml-prefix=#{INSTALL_TO}"
    parts << "--with-libxml-include-prefix=#{INSTALL_TO}/include"
    parts << "--with-libxml-libs-prefix=#{INSTALL_TO}/lib"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-xsl=shared,#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'lib', 'libxslt.a'))
  end
end
