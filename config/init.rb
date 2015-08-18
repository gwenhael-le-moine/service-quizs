# -*- coding: utf-8 -*-

puts 'loading config/options'
require __dir__('options')

puts 'loading config/database'
require __dir__('database')

puts 'loading config/common'
require_relative './common'

