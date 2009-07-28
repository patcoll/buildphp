# http://www.libgd.org/releases/gd-2.0.35.tar.gz
class Gd < Package
  PACKAGE_VERSION = '2.0.35'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '2.0.35' => { :md5 => '982963448dc36f20cb79b6e9ba6fdede' },
    }
  end
  
  def package_depends_on
    [
      'iconv',
      'freetype',
      'jpeg',
      'png',
      'zlib',
      'xpm',
    ]
  end
  
  def package_name
    'gd-%s.tar.gz' % @version
  end
  
  def package_dir
    'gd-%s' % @version
  end
  
  def package_location
    'http://www.libgd.org/releases/%s' % package_name
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts << "--with-libiconv-prefix=#{Iconv::PACKAGE_PREFIX}"
    parts << "--with-freetype=#{Freetype::PACKAGE_PREFIX}"
    parts << "--with-jpeg=#{Jpeg::PACKAGE_PREFIX}"
    parts << "--with-png=#{Png::PACKAGE_PREFIX}"
    parts << "--with-xpm=#{Xpm::PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-gd=shared,#{PACKAGE_PREFIX}",
      "--with-freetype-dir=#{Freetype::PACKAGE_PREFIX}",
      "--with-jpeg-dir=#{Jpeg::PACKAGE_PREFIX}",
      "--with-png-dir=#{Png::PACKAGE_PREFIX}",
      "--with-zlib-dir=#{Zlib::PACKAGE_PREFIX}",
      "--with-xpm-dir=#{Xpm::PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libgd.*"].empty?
  end
end
