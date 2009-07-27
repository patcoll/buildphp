class Bz2 < BuildTaskAbstract
  PACKAGE_VERSION = '1.0.5'
  
  def versions
    {
      '1.0.5' => { :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a' },
    }
  end
  
  def package_name
    'bzip2-%s.tar.gz' % @version
  end
  
  def package_dir
    'bzip2-%s' % @version
  end
  
  def package_location
    'http://www.bzip.org/%s/%s' % [@version, package_name]
  end
  
  def php_config_flags
    [
      "--with-bz2=shared,#{INSTALL_TO}",
    ]
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'include', 'bzlib.h'))
  end
end

