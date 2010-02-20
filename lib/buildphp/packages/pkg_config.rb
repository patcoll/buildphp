:pkg_config.version '0.23', :md5 => 'd922a88782b64441d06547632fd85744'

package :pkg_config do
  @version = '0.23'
  @file = "pkg-config-#{@version}.tar.gz"
  @location = "http://pkgconfig.freedesktop.org/releases/#{@file}"
  
  configure do |c|
    c << './configure'
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
  end
  
  def is_installed
    File.file? "#{@prefix}/bin/pkg-config"
  end
end
