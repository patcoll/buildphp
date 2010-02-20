:gd.version '2.0.35', :md5 => '982963448dc36f20cb79b6e9ba6fdede'

package :gd => %w(iconv freetype jpeg png zlib) do
  @version = '2.0.35'
  @file = "gd-#{@version}.tar.gz"
  @location = "http://www.libgd.org/releases/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--with-freetype=#{FACTORY.freetype.prefix}"
    c << "--with-jpeg=#{FACTORY.jpeg.prefix}"
    c << "--with-png=#{FACTORY.png.prefix}"
    c << "--without-fontconfig"
    c << "--without-xpm"
  end
  
  configure :php do |c|
    c << "--with-gd=shared,#{@prefix}"
    c << "--with-freetype-dir=#{FACTORY.freetype.prefix}"
    c << "--with-jpeg-dir=#{FACTORY.jpeg.prefix}"
    c << "--with-png-dir=#{FACTORY.png.prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libgd.*"].empty?
  end
end
