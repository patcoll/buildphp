:perl.version '5.10.1', :md5 => 'b9b2fdb957f50ada62d73f43ee75d044'

package :perl do
  @version = '5.10.1'
  @file = "perl-#{@version}.tar.gz"
  @location = "http://www.cpan.org/src/#{@file}"
  
  configure do |c|
    c << 'sh Configure -de'
    c << "-Duse64bitall" if is_linux? and system_is_64_bit?
    c << "-Dprefix='#{@prefix}'"
  end
  
  def is_installed
    File.file? "#{@prefix}/bin/perl"
  end
end
