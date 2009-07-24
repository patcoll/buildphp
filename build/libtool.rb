# http://ftp.gnu.org/gnu/libtool/libtool-2.2.6a.tar.gz

class Libtool < BuildTaskAbstract
  VERSION = '2.2.6a'
  
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
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM == 'x86_64-linux'
    parts << "--prefix=#{INSTALL_TO}"
    parts.join(' ')
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'lib', 'libtoolwhat.a'))
  end
end
