:kerberos.version '1.7', :md5 => '9f7b3402b4731a7fa543db193bf1b564'

package :kerberos => :ncurses do
  @version = '1.7'
  @file = "krb5-#{@version}-signed.tar"
  @location = "http://web.mit.edu/kerberos/dist/krb5/#{@version}/#{@file}"

  def package_dir
    "krb5-#{@version}"
  end
  
  def extract_dir
    File.join(extract_dir, 'src')
  end
  
  def extract_cmd
    "tar xf #{@file} && tar xfz krb5-#{@version}.tar.gz"
  end
  
  configure do |c|
    c << "./configure"
    c << "--prefix=#{@prefix}"
    c << "--disable-thread-support"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libkrb5.*"].empty?
  end

  # completely disable installing this package (for now).
  rake do
    Rake.application[to_sym].clear
    Rake.application.in_namespace(to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
  end
end
