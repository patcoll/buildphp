# http://downloads.sourceforge.net/project/libpng/00-libpng-stable/1.2.38/libpng-1.2.38.tar.gz?use_mirror=voxel
class Png < Package
  PACKAGE_VERSION = '1.2.38'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '1.2.38' => { :md5 => '99900634a47041607a031aa597d51e65' },
    }
  end
  
  def package_name
    'libpng-%s.tar.gz' % @version
  end
  
  def package_dir
    'libpng-%s' % @version
  end
  
  def package_location
    'http://downloads.sourceforge.net/project/libpng/00-libpng-stable/%s/%s?use_mirror=voxel' % [@version, package_name]
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/libpng.*"].empty?
  end
end
