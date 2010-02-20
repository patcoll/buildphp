:gettext.version '0.17', :md5 => '58a2bc6d39c0ba57823034d55d65d606'

package :gettext => %w(expat iconv ncurses xml) do
  @version = '0.17'
  @file = "gettext-#{@version}.tar.gz"
  @location = "http://ftp.gnu.org/pub/gnu/gettext/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--disable-java"
    c << "--disable-native-java"
    c << "--disable-threads"
    c << "--with-libexpat-prefix=#{FACTORY.expat.prefix}"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--with-libncurses-prefix=#{FACTORY.ncurses.prefix}"
    c << "--with-libxml2-prefix=#{FACTORY.xml.prefix}"
  end
  
  configure :php do |c|
    c << "--with-gettext=shared,#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libgettextlib.*"].empty?
  end
end
