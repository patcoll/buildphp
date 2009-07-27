# http://download.icu-project.org/files/icu4c/4.2.1/icu4c-4_2_1-src.tgz
class Icu < BuildTaskAbstract
  PACKAGE_VERSION = '4.2.1'
  
  def versions
    {
      '4.2.1' => { :md5 => 'e3738abd0d3ce1870dc1fd1f22bba5b1' },
    }
  end
  
  def package_name
    'icu4c-%s-src.tgz' % @version.gsub(/\./, '_')
  end
  
  def package_dir
    'icu/source'
  end
  
  def package_location
    'http://download.icu-project.org/files/icu4c/%s/%s' % [@version, package_name]
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{INSTALL_TO}"
    # parts << "--with-libxml-prefix=#{INSTALL_TO}"
    # parts << "--with-libxml-include-prefix=#{INSTALL_TO}/include"
    # parts << "--with-libxml-libs-prefix=#{INSTALL_TO}/lib"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-icu-dir=#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'lib', 'sdadasdasdasda.a'))
  end
end
