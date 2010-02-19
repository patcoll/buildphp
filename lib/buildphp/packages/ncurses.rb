:ncurses.version '5.7', :md5 => 'cce05daf61a64501ef6cd8da1f727ec6'

package :ncurses => :libtool do
  @version = '5.7'
  @file = "ncurses-#{@version}.tar.gz"
  @location = "http://ftp.gnu.org/pub/gnu/ncurses/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--without-debug"
    c << "--with-shared"
    # disable c++ support
    # c << "--without-cxx"
    # c << "--without-cxx-binding"
    c << "--with-libtool"
    c << "--enable-termcap"
  end
  
  def is_compiled
    not FileList["#{extract_dir}/**/*.lo"].empty?
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libncurses.*"].empty?
  end
end
