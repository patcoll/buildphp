# http://mirror.its.uidaho.edu/pub/savannah/freetype/freetype-2.3.9.tar.gz
class Freetype < Package
  PACKAGE_VERSION = '2.3.9'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '2.3.9' => { :md5 => '9c2744f1aa72fe755adda33663aa3fad' },
    }
  end
  
  def package_name
    'freetype-%s.tar.gz' % @version
  end
  
  def package_dir
    'freetype-%s' % @version
  end
  
  def package_location
    'http://mirror.its.uidaho.edu/pub/savannah/freetype/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts << "--without-zlib"
    parts.join(' ')
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libfreetype.*"].empty?
  end
end
