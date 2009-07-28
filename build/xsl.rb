class Xsl < Package
  PACKAGE_VERSION = '1.1.22'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
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
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts << "--with-libxml-prefix=#{PACKAGE_PREFIX}"
    parts << "--with-libxml-include-prefix=#{PACKAGE_PREFIX}/include"
    parts << "--with-libxml-libs-prefix=#{PACKAGE_PREFIX}/lib"
    parts << "--without-python"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-xsl=shared,#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libxslt.*"].empty?
  end
end
