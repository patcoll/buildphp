namespace :bz2 do
  task :get do
    FACTORY.get('Bz2').get()
  end
  
  task :compile => ((FACTORY.get('Bz2').package_depends_on || []) + [:get]) do
    cmd = "make"
    # bz2 does not detect whether to compile with position-independent code (PIC) or not, so we must decide that.
    # If we detect x86_64-linux as the platform, prepend -fPIC flag to gcc compile options to enable PIC.
    # http://en.wikipedia.org/wiki/Position_independent_code
    # 
    # Ideally, we should detect the platform and use the appropriate PIC flag for that platform.
    # 
    # If we don't do this, while compiling PHP will complain that bz2 was not compiled with PIC.
    if RUBY_PLATFORM.index("x86_64") != nil
      # use GNU sed options because we're on linux
      cmd = "sed -r -i.bak -e 's/^(CFLAGS=)(.+)$/\\1-fPIC \\2/' Makefile && make"
    end
    FACTORY.get('Bz2').compile(cmd)
  end
  
  task :install => :compile do
    FACTORY.get('Bz2').install("make install PREFIX=#{INSTALL_TO}")
  end
end

task :bz2 => 'bz2:install'