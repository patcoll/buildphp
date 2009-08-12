# http://web.mit.edu/kerberos/dist/krb5/1.7/krb5-1.7-signed.tar
module Buildphp
  class Kerberos < Package
    def initialize
      super
      @version = '1.7'
      @versions = {
        '1.7' => { :md5 => '9f7b3402b4731a7fa543db193bf1b564' },
      }
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_name
      'krb5-%s-signed.tar' % @version
    end
  
    def package_dir
      'krb5-%s' % @version
    end
  
    def package_location
      'http://web.mit.edu/kerberos/dist/krb5/%s/%s' % [@version, package_name]
    end
  
    def extract_dir
      File.join(EXTRACT_TO, package_dir, 'src')
    end
  
    def extract_cmd
      "tar xf %s && tar xfz krb5-%s.tar.gz" % [package_name, @version]
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      # parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts << "--prefix=#{@prefix}"
      parts << "--disable-thread-support"
      parts.join(' ')
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libkrb5.*"].empty?
    end
  end
end