:perl.version '5.10.1', :md5 => 'b9b2fdb957f50ada62d73f43ee75d044'

package :perl do |perl|
  perl.version = '5.10.1'
  perl.file = "perl-#{perl.version}.tar.gz"
  perl.location = "http://www.cpan.org/src/#{perl.file}"
  
  perl.configure do |c|
    c << 'sh Configure -de'
    c << "-Duse64bitall" if system_is_64_bit?
    c << "-Dprefix='#{perl.prefix}'"
  end
  
  perl.create_method :is_installed do
    File.file? "#{perl.prefix}/bin/perl"
  end
  
  perl.rake
end
