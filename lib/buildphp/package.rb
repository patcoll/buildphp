require 'digest/md5'

module Buildphp
  class Package
    attr_accessor :version
    attr_accessor :versions
    attr_accessor :prefix
    attr_accessor :is_pecl

    def initialize
      @versions = {}
      @version = self.class::PACKAGE_VERSION if self.class.const_defined?('PACKAGE_VERSION')
      @prefix = Buildphp::INSTALL_TO
      @is_pecl = false
    end
    
    def __class__
      self.class.to_s.split('::')[-1]
    end

    def to_s
      Inflect.underscore(__class__)
    end

    def to_sym
      to_s.to_sym
    end

    def console_prefix
      "[#{self}] "
    end
    
    def package_dependencies(force=false)
      return [] if is_installed unless force
      return package_depends_on
    end

    def package_depends_on
      []
    end

    def package_name
      nil
    end

    def package_dir
      nil
    end

    def package_location
      nil
    end

    def package_path
      return nil if not package_name
      File.join(Buildphp::EXTRACT_TO, package_name)
    end

    def package_md5
      versions[@version][:md5]
    end

    def php_config_flags
      []
    end

    def extract_dir
      return nil if not package_dir
      File.join(Buildphp::EXTRACT_TO, package_dir)
    end

    def extract_cmd
      "tar xfz %s" % package_name
    end

    def flags
      f = []

      # Mac Universal Binary flags? TODO: test Mac Universal Binary flags
      # flags = "-O3 -arch i386 -arch x86_64 -arch ppc7400 -arch ppc64"

      # enable PIC
      if RUBY_PLATFORM.index("x86_64") != nil
        f << "-fPIC"
      end

      # -fno-common enables PIC on Darwin
      # f << "-fno-common"

      f = f.join(' ')

      out = []
      out << %{ CFLAGS='#{f}' LDFLAGS='#{f}' CXXFLAGS='#{f}' } if f
      out << %{ PATH="#{Buildphp::INSTALL_TO}/bin":$PATH }

      out.join(' ')
    end

    def stop(msg)
      abort console_prefix + msg
    end

    def notice(msg)
      puts console_prefix + msg
    end

    def get_build_string
      "./configure --prefix=#{@prefix}"
    end

    def configure_cmd
      get_build_string
    end

    def compile_cmd
      'make -j'
    end

    def install_cmd
      'make install'
    end

    def clean_cmd
      'make clean'
    end

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
      return false if not File.exist?(package_path)
      package_md5 == Digest::MD5.hexdigest(File.read(package_path))
    end

    def get(force=false)
      retrieve(force)
      # if we get here we know the package has been downloaded
      Dir.chdir(Buildphp::EXTRACT_TO) do
        # remove folder if already extracted.
        # sh "rm -rf #{extract_dir}" if extract_dir and File.exist?(extract_dir) and options[:force]

        # only extract archive if not already extracted.
        sh extract_cmd if (not is_installed or force) and extract_dir and not File.exist?(extract_dir)
      end
      return true
    end # /get

    def retrieve(force=false)
      if not is_gotten or (not File.exist?(extract_dir) and force)
        notice "package not found. retrieving..." if not is_gotten
        Dir.chdir(Buildphp::EXTRACT_TO) do
          # get
          unless is_md5_verified
            sh "rm -f #{package_name} && wget #{package_location}" do |ok,res|
              stop "download failed" if not ok
              notice "download succeeded!"
            end
          end
          # verify
          stop 'md5 does not match' if not is_md5_verified
        end
      else
        notice "already downloaded"
      end
    end

    def configure(force=false)
      clean if force
      if is_installed and not force
        notice "already installed so we won't configure. try #{self}:force:configure"
      elsif not is_compiled
        notice "package not compiled. configuring..." if not is_compiled
        stop "extract folder does not exist" if not File.exists?(extract_dir)
        Dir.chdir(extract_dir) do
          sh configure_cmd do |ok,res|
            stop "configure failed" if not ok
            notice "configure succeeded!"
          end
        end
      end
      return true
    end # /configure

    def compile(force=false)
      clean if force
      if is_installed and not force
        notice "already installed so we won't compile. try #{self}:force:compile"
      elsif not is_compiled
        notice "package not compiled. compiling..." if not is_compiled
        Dir.chdir(extract_dir) do
          sh compile_cmd do |ok,res|
            if not ok then
              # do a  make clean if the compile fails. we don't want a half-compiled package.
              clean
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

    def install(force=false)
      if is_installed and not force
        notice "already installed. to force install, try #{self}:force:install"
      elsif not is_installed or force
        notice "package not installed. installing..." if not is_installed
        Dir.chdir(extract_dir) do
          sh install_cmd do |ok,res|
            stop "install failed" if not ok
            notice "install succeeded!"
          end
        end
      else
        notice "already installed"
      end
      return true
    end # /install

    def clean
      notice "cleaning..."
      Dir.chdir(extract_dir) do
        if not File.file?(File.join(extract_dir, "Makefile")) then
          notice "No Makefile; cannot clean..."
          return true
        end
        sh clean_cmd do |ok,res|
          stop "clean failed" if not ok
          notice "clean succeeded!"
        end
      end
      return true
    end # /clean

    def clobber
      notice "clobbering #{self}..."
      sh "rm -r #{extract_dir}" if extract_dir and File.exist?(extract_dir)
    end

    def rake
      namespace to_sym do
        task :get do
          get
        end

        task :configure => ((package_dependencies || []) + [:get]) do
          configure
        end

        task :compile => :configure do
          compile
        end

        task :install => :compile do
          install
        end

        task :clean do
          clean
        end

        task :clobber do
          clobber
        end

        task :retrieve do
          retrieve
        end

        namespace :force do
          task :get do
            get(true)
          end
          task :configure => ((package_dependencies(true) || []) + ["#{self}:force:get"]) do
            configure(true)
          end
          task :compile => "#{self}:force:configure" do
            compile(true)
          end
          task :install => "#{self}:force:compile" do
            install(true)
          end
        end

      end

      task to_sym => "#{self}:install"
    end

    def build_as_addon(options={})
      options = {
        :name => self.to_s,
        :ini_file => FACTORY['php'].custom_ini(self.to_s)
      }.merge(options)
      # p options
      # stop "#{name} package does not exist" if name and not FACTORY[name]

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
          if not already_activated then
            sh %[echo '#{new_line}' >> #{options[:ini_file]}] do |ok,res|
              notice "#{self} activated!" if ok
              stop "#{self} activation failed" if not ok
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