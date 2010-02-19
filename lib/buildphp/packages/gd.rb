:gd.version '2.0.35', :md5 => '982963448dc36f20cb79b6e9ba6fdede'

package :gd => %w(iconv freetype jpeg png zlib) do |gd|
  gd.version = '2.0.35'
  gd.file = "gd-#{gd.version}.tar.gz"
  gd.location = "http://www.libgd.org/releases/#{gd.file}"
  
  gd.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{gd.prefix}"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--with-freetype=#{FACTORY.freetype.prefix}"
    c << "--with-jpeg=#{FACTORY.jpeg.prefix}"
    c << "--with-png=#{FACTORY.png.prefix}"
    c << "--without-fontconfig"
    c << "--without-xpm"
  end
  
  gd.configure :php do |c|
    c << "--with-gd=shared,#{gd.prefix}"
    c << "--with-freetype-dir=#{FACTORY.freetype.prefix}"
    c << "--with-jpeg-dir=#{FACTORY.jpeg.prefix}"
    c << "--with-png-dir=#{FACTORY.png.prefix}"
  end
  
  gd.create_method :is_installed do
    not FileList["#{gd.prefix}/lib/libgd.*"].empty?
  end
  
  gd.rake
end
