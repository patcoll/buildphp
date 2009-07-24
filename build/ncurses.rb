# http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz

class Ncurses < BuildTaskAbstract
  VERSION = '5.7'
  
  def versions
    {
      '5.7' => { :md5 => 'cce05daf61a64501ef6cd8da1f727ec6' },
    }
  end
  
  def package_depends_on
    [
      'libtool',
    ]
  end
  
  def package_name
    'ncurses-%s.tar.gz' % @version
  end
  
  def package_dir
    'ncurses-%s' % @version
  end
  
  def package_location
    'http://ftp.gnu.org/pub/gnu/ncurses/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM == 'x86_64-linux'
    parts << "--prefix=#{INSTALL_TO}"
    parts << "--without-debug"
    parts << "--with-shared"
    parts << "--with-libtool"
    parts << "--enable-termcap"
    parts.join(' ')
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'lib', 'libncurses.a'))
  end
end
