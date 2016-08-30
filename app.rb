# coding: utf-8

require 'rubygems'
require 'bundler'

Bundler.require(:default, :development)

# DIR Method
def __dir__(*args)
  filename = caller[0][/^(.*):/, 1]
  dir = File.expand_path(File.dirname(filename))
  ::File.expand_path(::File.join(dir, *args.map(&:to_s)))
end

require 'laclasse/laclasse_logger'
# initialisation du logger
LOGGER = Laclasse::LoggerFactory.get_logger

require 'laclasse/helpers/app_infos'

puts '----------> configs <----------'
require __dir__('config/init')
puts '----------> models <-----------'
require __dir__('model/init')
puts '----------> libs <-----------'
require __dir__('lib/init')
puts '----------> objects <-----------'
require __dir__('object/init')
puts '----------> api <--------------'
require __dir__('api/init')
puts '----------> controllers <------'
require __dir__('controller/init')
