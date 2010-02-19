# :kerberos.version '1.7', :md5 => '9f7b3402b4731a7fa543db193bf1b564'
# 
# package :kerberos => :ncurses do |kerberos|
#   kerberos.version = '1.7'
#   kerberos.file = "krb5-#{kerberos.version}-signed.tar"
#   kerberos.location = "http://web.mit.edu/kerberos/dist/krb5/#{kerberos.version}/#{kerberos.file}"
# 
#   kerberos.create_method :package_dir do
#     "krb5-#{kerberos.version}"
#   end
#   
#   kerberos.create_method :extract_dir do
#     File.join(kerberos.extract_dir, 'src')
#   end
#   
#   kerberos.create_method :extract_cmd do
#     "tar xf #{kerberos.file} && tar xfz krb5-#{kerberos.version}.tar.gz"
#   end
#   
#   kerberos.configure do |c|
#     c << "./configure"
#     c << "--prefix=#{kerberos.prefix}"
#     c << "--disable-thread-support"
#   end
#   
#   kerberos.create_method :is_installed do
#     not FileList["#{kerberos.prefix}/lib/libkrb5.*"].empty?
#   end
#   
#   kerberos.rake
# end
