#

@config = {
  :package => 'php-5.2.9.tar.gz',
  :src => File.join(Dir.pwd, 'local')
}

desc 'PHP'
namespace :php do

  desc 'Grab PHP from the server'
  task :get do
    # puts this.config
    # Dir.mkdir(build[:php]) unless File.exist?(build[:php])
    Dir.chdir(build[:php]) do
      sh "wget #{packages[:php]}"
      sh "tar xfz #{File.basename(packages[:php])}"
      # puts 
      # `rm -rf #{packages[:php]}`
    end
  end
  
  desc 'Configure PHP'
  task :configure => (%w{ mysql:install } + [:get]) do
    require File.join(build[:php], '../', 'build.rb')
    Dir.chdir(File.join(build[:php], get_dir_name(packages[:php]))) do
      # puts Dir.pwd
      # puts get_build_string(config[:install_dir])
      # `#{get_build_string(config[:install_dir])}`
    end
  end

  desc 'Compile PHP'
  task :compile => :configure do
    
  end
  
  desc 'Install PHP'
  task :install => :compile do
    # sh "rm -rf #{File.join(build[:php], '*')}"
    puts config[:package]
  end
  
  def get_build_string(install_dir)
    parts = %w{ ./configure }
    
    # Apache2
    # parts.push "--with-apxs2=#{install_dir}/sbin/apxs"
    
    # FastCGI
    parts.push "--enable-fastcgi"
    parts.push "--enable-discard-path"
    parts.push "--enable-force-cgi-redirect"
    
    # install_dir
    parts.push "--prefix=#{install_dir}"
    parts.push "--with-config-file-path=#{install_dir}/etc"
    parts.push "--with-config-file-scan-dir=#{install_dir}/etc/php.d"
    parts.push "--with-pear=#{install_dir}/share/pear"
    parts.push "--disable-debug"
    parts.push "--disable-rpath"
    parts.push "--enable-inline-optimization"
    
    
    
    parts.join(' ')
  end
end







# 
# --with-bz2=shared
# --with-db4=shared,/usr
# --with-curl=shared
# --with-freetype-dir=/opt/local
# --with-png-dir=/usr
# --with-gd=shared,/opt/local
# --enable-gd-native-ttf
# --without-gdbm
# --with-gettext=shared
# --with-ncurses=shared
# --with-gmp=shared
# --with-iconv=shared
# --with-jpeg-dir=/opt/local
# --with-openssl=shared
# --with-png-dir=/opt/local
# --with-pspell=shared,/opt/local
# --with-xml=shared
# --with-expat-dir=/usr
# --with-dom=shared,/usr
# --with-dom-xslt=shared,/usr
# --with-dom-exslt=shared,/usr
# --with-xmlrpc=shared
# --with-pcre-regex=/opt/local
# --with-zlib=shared
# --enable-bcmath
# --enable-exif
# --enable-ftp
# --enable-sockets
# --enable-sysvsem
# --enable-sysvshm
# --enable-track-vars
# --enable-trans-sid
# --enable-yp
# --enable-wddx
# --with-pear=/opt/local/pear
# --with-imap=shared,/opt/local/imap-2006h
# --with-imap-ssl=shared
# --with-kerberos
# --with-ldap=shared
# --with-mysql=shared,/opt/local/mysql
# --with-pdo-mysql=shared,/opt/local/mysql
# --with-pgsql=shared,/opt/local
# --with-pdo-pgsql=shared,/opt/local
# --enable-ucd-snmp-hack
# --with-unixODBC=shared,/usr
# --enable-memory-limit
# --enable-shmop
# --enable-calendar
# --enable-dbx
# --enable-dio
# --enable-mbstring
# --enable-mbstr-enc-trans
# --enable-mbregex
# --with-xsl=shared,/usr/local
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # Build as Apache 2 module.
# # parts.push '--with-apxs2=/usr/sbin/apxs'
# 
# # Build as FastCGI binary.
# # parts.push '--enable-discard-path'
# # parts.push '--enable-force-cgi-redirect'
# 
# # PHP Configuration
# parts.push '--prefix=/usr/local'
# parts.push '--with-config-file-path=/usr/local/etc'
# parts.push '--with-config-file-scan-dir=/usr/local/etc/php.d'
# parts.push '--with-pear=/usr/share/pear'
# parts.push '--disable-debug'
# parts.push '--disable-rpath'
# parts.push '--enable-inline-optimization'
# # parts.push '--enable-memory-limit'
# 
# # Database support
# # parts.push '--with-db4=shared,/usr'
# parts.push '--without-gdbm'
# parts.push '--with-mysql=mysqlnd'
# parts.push '--with-mysqli=mysqlnd'
# parts.push '--with-pdo-mysql=mysqlnd'
# # parts.push '--with-unixODBC=shared,/usr'
# 
# # Extensions
# parts.push '--with-bz2=shared'
# parts.push '--with-curl=shared'
# parts.push '--with-freetype-dir=/opt/local'
# parts.push '--with-png-dir=/usr'
# parts.push '--with-gd=shared,/opt/local'
# parts.push '--enable-gd-native-ttf'
# # parts.push '--with-gettext=shared'
# # parts.push '--with-ncurses=shared'
# # parts.push '--with-gmp=shared'
# parts.push '--with-iconv=shared'
# parts.push '--enable-json'
# # parts.push '--enable-intl'
# parts.push '--with-jpeg-dir=/opt/local'
# parts.push '--with-openssl=shared'
# parts.push '--with-png-dir=/opt/local'
# # parts.push '--with-pspell=shared,/opt/local'
# # parts.push '--with-xml=shared'
# # parts.push '--with-expat-dir=/usr'
# # parts.push '--with-dom=shared,/usr'
# # parts.push '--with-dom-xslt=shared,/usr'
# # parts.push '--with-dom-exslt=shared,/usr'
# parts.push '--with-xmlrpc=shared'
# parts.push '--with-pcre-regex=/opt/local'
# parts.push '--with-zlib=shared'
# parts.push '--enable-bcmath'
# parts.push '--enable-exif'
# parts.push '--enable-ftp'
# parts.push '--enable-sockets'
# parts.push '--enable-sysvsem'
# parts.push '--enable-sysvshm'
# # parts.push '--enable-track-vars'
# # parts.push '--enable-trans-sid'
# # parts.push '--enable-yp'
# parts.push '--enable-wddx'
# parts.push '--with-kerberos'
# parts.push '--with-ldap=shared'
# parts.push '--enable-shmop'
# parts.push '--enable-calendar'
# # parts.push '--enable-dio'
# # parts.push '--enable-dbx'
# parts.push '--enable-mbstring'
# # parts.push '--enable-mbstr-enc-trans'
# parts.push '--enable-mbregex'
# # parts.push '--with-mime-magic=/usr/share/file/magic.mime'
# parts.push '--with-xsl=shared,/usr/local'
# 
# parts
# 
# # system(parts.join(' '))
# 
# # puts $?.exitstatus
# 
# # directorylist = %x[#{parts.join(' ')}]
# 
# # Open3.popen3() { |stdin, stdout, stderr| puts stdout }
# 
# # abort
