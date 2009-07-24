# http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.12.tar.gz
class Iconv < BuildTaskAbstract
  VERSION = '1.12'
  
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
    "./configure --prefix=#{INSTALL_TO}"
  end
  
  def php_config_flags
    [
      "--with-iconv-dir=shared,#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'bin', 'iconv'))
  end
end
