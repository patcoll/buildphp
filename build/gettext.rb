# http://ftp.gnu.org/pub/gnu/gettext/gettext-0.17.tar.gz
class Gettext < Package
  PACKAGE_VERSION = '0.17'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '0.17' => { :md5 => '58a2bc6d39c0ba57823034d55d65d606' },
    }
  end
  
  def package_depends_on
    [
      'expat',
      'iconv',
      'ncurses',
      'xml',
    ]
  end
  
  def package_name
    'gettext-%s.tar.gz' % @version
  end
  
  def package_dir
    'gettext-%s' % @version
  end
  
  def package_location
    'http://ftp.gnu.org/pub/gnu/gettext/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts << "--disable-java"
    parts << "--disable-native-java"
    parts << "--disable-threads"
    parts << "--with-libiconv-prefix=#{Iconv::PACKAGE_PREFIX}"
    parts << "--with-libncurses-prefix=#{Ncurses::PACKAGE_PREFIX}"
    parts << "--with-libxml2-prefix=#{Xml::PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-gettext=shared,#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libgettextlib.*"].empty?
  end
end
