class Libtool < BuildTaskAbstract
  PACKAGE_VERSION = '2.2.6a'
  
  def versions
    {
      '2.2.6a' => { :md5 => '8ca1ea241cd27ff9832e045fe9afe4fd' },
    }
  end
  
  def package_name
    'libtool-2.2.6a.tar.gz'
  end
  
  def package_dir
    'libtool-2.2.6'
  end
  
  def package_location
    'http://ftp.gnu.org/gnu/libtool/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{INSTALL_TO}"
    parts.join(' ')
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'bin', 'libtool'))
  end
end
