# encoding utf-8

APPLICATION_PATH  = File.expand_path(File.dirname(__FILE__))

require_relative 'app/controllers/base'

run Vdb::API
