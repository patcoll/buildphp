class Iconv < BuildTaskAbstract
  PACKAGE_VERSION = '1.12'
  
  def versions
    {
      '1.12' => { :md5 => 'c2be282595751535a618ae0edeb8f648' },
    }
  end
  
  def package_name
    'libiconv-%s.tar.gz' % @version
  end
  
  def package_dir
    'libiconv-%s' % @version
  end
  
  def package_location
    'http://ftp.gnu.org/pub/gnu/libiconv/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{INSTALL_TO}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-iconv=shared",
      "--with-iconv-dir=#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'bin', 'iconv'))
  end
end
