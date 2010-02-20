require 'digest/md5'

module Buildphp
  class Package
    attr_reader :name
    attr_accessor :versions, :version, :depends_on, :file, :location, :prefix
    attr_accessor :compile_cmd, :install_cmd, :clean_cmd

    def initialize(name)
      @name = name.to_s
      raise Exception.new('must provide a package name') if @name.empty?

      @versions = Hash.new
      @version = ''
      @version = self.class::PACKAGE_VERSION if self.class.const_defined?('PACKAGE_VERSION')
      @depends_on = Array.new
      @file = ''
      @location = ''
      @prefix = Buildphp::INSTALL_TO
      @configure = Array.new

      @compile_cmd = 'make -j2'
      @install_cmd = 'make install'
      @clean_cmd = 'make clean'
      @rake_tasks_declared = false
      # yield self if block_given?
      # rake
    end

    # include Capistrano::Configuration::Variables

    def add_attr(*attrs)
      attrs.each do |attr|
        instance_eval %Q{
          def #{attr}
            @#{attr}
          end

          def #{attr}=(val)
            @#{attr} = val
          end
        }
      end
    end

    # def package(&block)
    #   instance_eval(&block)
    # end

    # def create_method(name, &block)
    #   self.send(:define_method, name, &block)
    # end
    # allows appending of configure flags for the current package (default)
    #
    # gd.configure do |c|
    #   c << '--with-whatever=prefix'
    # end
    #
    # or alternatively append configure flags for other packages:
    #
    # gd.configure :php do |c|
    #   c << '--with-gd=prefix'
    # end
    def configure(*args)
      conf_target = self
      if args[0].is_a?(String) or args[0].is_a?(Symbol)
        conf_target = FACTORY.send(args[0].to_sym)
      end
      yield conf_target.instance_variable_get("@configure") if block_given?
      conf_target.instance_variable_get("@configure").join(' ')
    end

    def to_s
      name
    end

    def to_sym
      to_s.to_sym
    end

    def console_prefix
      "[#{self}] "
    end

    # def package_dependencies(force=false)
    #   return [] if is_installed unless force
    #   return package_depends_on
    # end

    def package_depends_on
      depends_on
    end

    def package_name
      file
    end

    def package_dir
      dots = case package_name
        when /\.tar\.(gz|bz2)$/: 2
        when /\.(tar|tgz|tbz2)$/: 1
      end
      s = package_name.split('.')
      s.slice(0,s.length-dots).join('.')
    end

    def package_location
      location
    end

    def package_path
      File.join(Buildphp::EXTRACT_TO, file)
    end

    def md5
      versions[version][:md5]
    end

    def extract_dir
      File.join(Buildphp::EXTRACT_TO, package_dir)
    end

    def extract_cmd
      tar_flags = case package_name
        when /\.(tar\.gz|tgz)$/: 'xfz'
        when /\.(tar\.bz2|tbz2)$/: 'xfj'
        when /\.tar$/: 'xf'
      end
      return nil if tar_flags.nil?
      "tar #{tar_flags} #{file}"
    end

    def flags
      f = []

      # Mac Universal Binary flags? TODO: test Mac Universal Binary flags
      # if RUBY_PLATFORM =~ /darwin/i
      #   f << "-O3 -arch i386 -arch x86_64 -arch ppc7400 -arch ppc64"
      # end

      # enable PIC
      if x86_64?
        f << "-fPIC"
      elsif RUBY_PLATFORM =~ /darwin/i
        # -fno-common enables PIC on Mac OS
        f << "-fno-common"
      end

      f << "-I#{Buildphp::INSTALL_TO}/include"
      f << "-L#{Buildphp::INSTALL_TO}/lib"

      f = f.join(' ')
    end

    def configure_prefix
      out = []
      out << "CFLAGS='#{flags}' LDFLAGS='#{flags}' CXXFLAGS='#{flags}'" if flags
      out << "PATH='#{Buildphp::INSTALL_TO}/bin':$PATH"
      out << "PKG_CONFIG_PATH='#{Buildphp::INSTALL_TO}/lib/pkgconfig'"
      out.join(' ')
    end

    def stop(msg)
      abort console_prefix + msg
    end

    def notice(msg)
      puts console_prefix + msg
    end

    def get_build_string
      [configure_prefix, configure].join(' ')
    end

    def configure_cmd
      get_build_string
    end

    # def compile_cmd
    #   'make -j2'
    # end
    #
    # def install_cmd
    #   'make install'
    # end
    #
    # def clean_cmd
    #   'make clean'
    # end

    def is_gotten
      File.exist?(package_path) && is_md5_verified
    end

    def is_compiled
      (not FileList["#{extract_dir}/*.o"].empty?) or (not FileList["#{extract_dir}/**/*.o"].empty?)
    end

    def is_installed
      false
    end

    def is_md5_verified
      return false unless File.exist?(package_path)
      md5 == Digest::MD5.hexdigest(File.read(package_path))
    end

    def rake
      namespace self.to_sym do
        task :get do
          get!
        end

        task :configure => :get do
          configure!
        end

        task :compile => :configure do
          compile!
        end

        task :install => :compile do
          install!
        end

        task :clean do
          clean!
        end

        task :clobber do
          clobber!
        end

        task :retrieve do
          retrieve!
        end

        namespace :force do
          task :get do
            force_get!
          end
          task :configure => "#{self}:force:get" do
            force_configure!
          end
          task :compile => "#{self}:force:configure" do
            force_compile!
          end
          task :install => "#{self}:force:compile" do
            force_install!
          end
        end

      end

      task self.to_sym => "#{self}:install"
      @rake_tasks_declared = true

      yield self if block_given?
    end

    def rake_tasks_declared?
      @rake_tasks_declared
    end

    def get!(force=false)
      retrieve!(force)
      # if we get here we know the package has been downloaded
      Dir.chdir(Buildphp::EXTRACT_TO) do
        # remove folder if already extracted.
        # sh "rm -rf #{extract_dir}" if extract_dir and File.exist?(extract_dir) and options[:force]

        # only extract archive unless already extracted.
        sh extract_cmd if (not is_installed or force) and extract_dir unless File.exist?(extract_dir)
      end
      return true
    end # /get

    def force_get!
      get! true
    end

    def retrieve!(force=false)
      unless is_gotten or (not File.exist?(extract_dir) and force)
        notice "package not found. retrieving..." unless is_gotten
        Dir.chdir(Buildphp::EXTRACT_TO) do
          # get
          unless is_md5_verified
            sh "rm -f #{package_name} && wget #{package_location}" do |ok,res|
              stop "download failed" unless ok
              notice "download succeeded!"
            end
          end
          # verify
          stop 'md5 does not match' unless is_md5_verified
        end
      else
        notice "already downloaded"
      end
    end

    def force_retrieve!
      retrieve! true
    end

    def configure!(force=false)
      clean! if force
      if is_installed and not force
        notice "already installed so we won't configure. try #{self}:force:configure"
      elsif not is_compiled
        notice "package not compiled. configuring..." unless is_compiled
        stop "extract folder does not exist" unless File.exists?(extract_dir)
        Dir.chdir(extract_dir) do
          sh configure_cmd do |ok,res|
            stop "configure failed" unless ok
            notice "configure succeeded!"
          end
        end
      end
      return true
    end # /configure

    def force_configure!
      configure! true
    end

    def compile!(force=false)
      clean! if force
      if is_installed and not force
        notice "already installed so we won't compile. try #{self}:force:compile"
      elsif not is_compiled
        notice "package not compiled. compiling..." unless is_compiled
        Dir.chdir(extract_dir) do
          sh compile_cmd do |ok,res|
            unless ok then
              # do a  make clean if the compile fails. we don't want a half-compiled package.
              clean!
              stop "compile failed"
            end
            notice "compile succeeded!"
          end
        end
      else
        notice "already compiled"
      end
      return true
    end # /compile

    def force_compile!
      compile! true
    end

    def install!(force=false)
      if is_installed and not force
        notice "already installed. to force install, try #{self}:force:install"
      elsif not is_installed or force
        notice "package not installed. installing..." unless is_installed
        Dir.chdir(extract_dir) do
          sh install_cmd do |ok,res|
            stop "install failed" unless ok
            notice "install succeeded!"
          end
        end
      else
        notice "already installed"
      end
      return true
    end # /install

    def force_install!
      install! true
    end

    def clean!
      notice "cleaning..."
      Dir.chdir(extract_dir) do
        unless File.file?(File.join(extract_dir, "Makefile")) then
          notice "No Makefile; cannot clean..."
          return true
        end
        sh clean_cmd do |ok,res|
          stop "clean failed" unless ok
          notice "clean succeeded!"
        end
      end
      return true
    end # /clean

    def clobber!
      notice "clobbering #{self}..."
      sh "rm -r #{extract_dir}" if extract_dir and File.exist?(extract_dir)
    end

    def build_as_addon(options={})
      options = {
        :name => self.to_s,
        :ini_file => FACTORY['php'].custom_ini(self.to_s)
      }.merge(options)
      # stop "#{name} package does not exist" if name unless FACTORY[name]

      # notify user after installation to run activate to activate module
      Rake.application["#{self}:install"].enhance do
        notice "after installation, run #{self}:activate to activate the #{self.to_s.upcase} pecl module."
      end
      # activate task
      # activates the module in a given php.ini file
      Rake.application.in_namespace(self.to_sym) do
        task :activate => :install do
          new_line = "extension=#{options[:name]}.so"
          already_activated = false
          sh %[grep #{new_line} #{options[:ini_file]}] do |ok,res|
            already_activated = ok
          end
          unless already_activated then
            sh %[echo '#{new_line}' >> #{options[:ini_file]}] do |ok,res|
              notice "#{self} activated!" if ok
              stop "#{self} activation failed" unless ok
            end
          else
            notice "#{self} already activated"
          end
        end
      end
      # e.g. make :memcache run the "memcache:activate" task
      Rake.application[self.to_sym].clear_prerequisites.enhance ["#{self}:activate"]
    end

  end
end