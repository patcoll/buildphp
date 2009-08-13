require 'buildphp/constants'
require 'buildphp/inflect'
require 'buildphp/package'
require 'buildphp/package_factory'
require 'buildphp/version'
Dir[File.join(File.dirname(__FILE__), 'buildphp/packages/*.rb')].each { |t| require t }