:pkg_config.version '0.23', :md5 => 'd922a88782b64441d06547632fd85744'

package :pkg_config do |pkg_config|
  pkg_config.version = '0.23'
  pkg_config.file = "pkg-config-#{pkg_config.version}.tar.gz"
  pkg_config.location = "http://pkgconfig.freedesktop.org/releases/#{pkg_config.file}"
  
  pkg_config.configure do |c|
    c << './configure'
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{pkg_config.prefix}"
  end
  
  pkg_config.create_method :is_installed do
    File.file? "#{pkg_config.prefix}/bin/pkg-config"
  end
  
  pkg_config.rake
end
