:gettext.version '0.17', :md5 => '58a2bc6d39c0ba57823034d55d65d606'

package :gettext => %w(expat iconv ncurses xml) do |gettext|
  gettext.version = '0.17'
  gettext.file = "gettext-#{gettext.version}.tar.gz"
  gettext.location = "http://ftp.gnu.org/pub/gnu/gettext/#{gettext.file}"
  
  gettext.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{gettext.prefix}"
    c << "--disable-java"
    c << "--disable-native-java"
    c << "--disable-threads"
    c << "--with-libexpat-prefix=#{FACTORY.expat.prefix}"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--with-libncurses-prefix=#{FACTORY.ncurses.prefix}"
    c << "--with-libxml2-prefix=#{FACTORY.xml.prefix}"
  end
  
  gettext.configure :php do |c|
    c << "--with-gettext=shared,#{gettext.prefix}"
  end
  
  gettext.create_method :is_installed do
    not FileList["#{gettext.prefix}/lib/libgettextlib.*"].empty?
  end
  
  gettext.rake
end
