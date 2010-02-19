# :iconv.version '1.12', :md5 => 'c2be282595751535a618ae0edeb8f648'

package :iconv do |iconv|
  # iconv.version = '1.12'
  # iconv.file = "libiconv-#{iconv.version}.tar.gz"
  # iconv.location = "http://ftp.gnu.org/pub/gnu/libiconv/#{iconv.file}"
  # 
  # iconv.configure do |c|
  #   c << "./configure"
  #   c << "--with-pic" if system_is_64_bit?
  #   c << "--prefix=#{iconv.prefix}"
  #   c << "--enable-relocatable"
  #   c << "--enable-static"
  #   c << "--enable-shared"
  # end
  # 
  # iconv.configure :php do |c|
  #   c << "--with-iconv=shared,#{iconv.prefix}"
  # end
  # 
  # iconv.create_method :is_compiled do
  #   not FileList["#{iconv.extract_dir}/src/*.o"].empty?
  # end
  # 
  # iconv.create_method :is_installed do
  #   not FileList["#{iconv.prefix}/lib/libiconv.*"].empty?
  # end

  iconv.rake do
    Rake.application[iconv.to_sym].clear
    Rake.application.in_namespace(iconv.to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
  end
end
