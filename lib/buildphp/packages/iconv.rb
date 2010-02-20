:iconv.version '1.12', :md5 => 'c2be282595751535a618ae0edeb8f648'

package :iconv do
  @version = '1.12'
  @file = "libiconv-#{@version}.tar.gz"
  @location = "http://ftp.gnu.org/pub/gnu/libiconv/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--enable-relocatable"
    c << "--enable-static"
    c << "--enable-shared"
  end
  
  configure :php do |c|
    c << "--with-iconv=shared,#{@prefix}"
  end
  
  def is_compiled
    not FileList["#{extract_dir}/src/*.o"].empty?
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libiconv.*"].empty?
  end

  # completely disable installing this package (for now).
  rake do
    Rake.application[to_sym].clear
    Rake.application.in_namespace(to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
  end
end
