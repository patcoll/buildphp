# # ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/openldap-2.4.17.tgz
# class Ldap < Buildphp::Package
#   # PACKAGE_PREFIX = "/Applications/MAMP/Library"
#   
#   def initialize
#     super
#     @version = '2.4.17'
#     @versions = {
#       '2.4.17' => { :md5 => '5e82103780f8cfc2b2fbd0f77c47c158' },
#     }
#   end
#   
#   def package_name
#     'openldap-%s.tgz' % @version
#   end
#   
#   def package_dir
#     'openldap-%s' % @version
#   end
#   
#   def package_location
#     'ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/%s' % [@version, package_name]
#   end
#   
#   def get_build_string
#     parts = []
#     parts << flags
#     parts << './configure'
#     parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
#     parts << "--without-threads"
#     parts << "--prefix=#{@prefix}"
#     parts.join(' ')
#   end
#   
#   def php_config_flags
#     [
#       "--with-ldap=shared,#{@prefix}",
#     ]
#   end
#   
#   def is_installed
#     false
#     not FileList["#{@prefix}/lib/libldapsdadsa.*"].empty?
#   end
# end
