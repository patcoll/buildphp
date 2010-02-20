:bz2.version '1.0.5', :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a'

package :bz2 do
  @version = '1.0.5'
  @file = "bzip2-#{@version}.tar.gz"
  @location = "http://www.bzip.org/#{@version}/#{@file}"
  
  configure do |c|
    c << "./configure"
  end

  configure :php do |c|
    c << "--with-bz2=shared,#{@prefix}"
  end

  # bz2 does not detect whether to compile with position-independent code (PIC) or not, so we must decide that.
  # If we detect x86_64-linux as the platform, prepend -fPIC flag to gcc compile options to enable PIC.
  # http://en.wikipedia.org/wiki/Position_independent_code
  # 
  # Ideally, we should detect the platform and use the appropriate PIC flag for that platform.
  # 
  # If we don't do this, while compiling PHP will complain that bz2 was not compiled with PIC.
  if x86_64?
    # use GNU sed options because we're on linux
    @compile_cmd = "sed -r -i.bak -e 's/^(CFLAGS=)(.+)$/\\1-fPIC \\2/' Makefile && #{@compile_cmd}"
  end
  
  @install_cmd = "make install PREFIX=#{@prefix}"
  
  def is_installed
    not FileList["#{@prefix}/lib/libbz2.*"].empty?
  end
  
  rake do
    # there is no configure phase for this package, so make compile! depend on get! directly.
    Rake.application["#{self}:compile"].clear_prerequisites.enhance [:get]
    Rake.application["#{self}:force:compile"].clear_prerequisites.enhance ["#{self}:force:get"]
  end
end
