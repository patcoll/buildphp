:libtool.version '2.2.6a', :md5 => '8ca1ea241cd27ff9832e045fe9afe4fd'

package :libtool do
  @version = '2.2.6a'
  @file = "libtool-#{@version}.tar.gz"
  @location = "http://ftp.gnu.org/gnu/libtool/#{@file}"
  
  def package_dir
    "libtool-2.2.6"
  end
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
  end

  def is_installed
    File.exists?(File.join(@prefix, 'bin', 'libtool'))
  end
end
