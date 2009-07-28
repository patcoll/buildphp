# http://www.openssl.org/source/openssl-0.9.8k.tar.gz
class Openssl < Package
  PACKAGE_VERSION = '0.9.8k'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '0.9.8k' => { :md5 => 'e555c6d58d276aec7fdc53363e338ab3' },
    }
  end
  
  def package_depends_on
    [
      'kerberos',
    ]
  end
  
  def package_name
    'openssl-%s.tar.gz' % @version
  end
  
  def package_dir
    'openssl-%s' % @version
  end
  
  def package_location
    'http://www.openssl.org/source/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './config'
    parts << "-fPIC" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-openssl=shared,#{PACKAGE_PREFIX}",
      "--with-openssl-dir=#{PACKAGE_PREFIX}",
      "--with-kerberos=#{Kerberos::PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libssl.*"].empty?
  end
end
