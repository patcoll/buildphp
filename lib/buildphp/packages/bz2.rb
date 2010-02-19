:bz2.version '1.0.5', :md5 => '3c15a0c8d1d3ee1c46a1634d00617b1a'

package :bz2 do |bz2|
  bz2.version = '1.0.5'
  bz2.file = "bzip2-#{bz2.version}.tar.gz"
  bz2.location = "http://www.bzip.org/#{bz2.version}/#{bz2.file}"
  
  bz2.configure do |c|
    c << "./configure"
  end

  bz2.configure :php do |c|
    c << "--with-bz2=shared,#{bz2.prefix}"
  end

  # bz2 does not detect whether to compile with position-independent code (PIC) or not, so we must decide that.
  # If we detect x86_64-linux as the platform, prepend -fPIC flag to gcc compile options to enable PIC.
  # http://en.wikipedia.org/wiki/Position_independent_code
  # 
  # Ideally, we should detect the platform and use the appropriate PIC flag for that platform.
  # 
  # If we don't do this, while compiling PHP will complain that bz2 was not compiled with PIC.
  if system_is_64_bit?
    # use GNU sed options because we're on linux
    bz2.compile_cmd = "sed -r -i.bak -e 's/^(CFLAGS=)(.+)$/\\1-fPIC \\2/' Makefile && #{bz2.compile_cmd}"
  end
  
  bz2.install_cmd = "make install PREFIX=#{bz2.prefix}"
  
  bz2.create_method :is_installed do
    not FileList["#{bz2.prefix}/lib/libbz2.*"].empty?
  end
  
  bz2.rake do
    Rake.application["#{bz2}:compile"].clear_prerequisites.enhance [(bz2.depends_on || []) + [:get]]
    Rake.application["#{bz2}:force:compile"].clear_prerequisites.enhance [(bz2.depends_on || []) + [:get]]
  end
end
