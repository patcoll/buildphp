:ncurses.version '5.7', :md5 => 'cce05daf61a64501ef6cd8da1f727ec6'

package :ncurses => :libtool do |ncurses|
  ncurses.version = '5.7'
  ncurses.file = "ncurses-#{ncurses.version}.tar.gz"
  ncurses.location = "http://ftp.gnu.org/pub/gnu/ncurses/#{ncurses.file}"
  
  ncurses.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{ncurses.prefix}"
    c << "--without-debug"
    c << "--with-shared"
    # disable c++ support
    # c << "--without-cxx"
    # c << "--without-cxx-binding"
    c << "--with-libtool"
    c << "--enable-termcap"
  end
  
  ncurses.create_method :is_compiled do
    not FileList["#{ncurses.extract_dir}/**/*.lo"].empty?
  end
  
  ncurses.create_method :is_installed do
    not FileList["#{ncurses.prefix}/lib/libncurses.*"].empty?
  end
  
  ncurses.rake
end
