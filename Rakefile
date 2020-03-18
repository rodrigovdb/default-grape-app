# frozen_string_literal: true

require 'bundler/setup'
load 'tasks/otr-activerecord.rake'
require './lib/loader'

desc 'Display API endpoints'
task :routes do
  require './app'

  app = Vdb::API
  puts "========== \e[34m#{app}\e[0m"
  app.routes.each do |resource|
    method = resource.request_method.ljust(10)
    path   = resource.path
    puts "#{method} #{path}"
  end
end

namespace :db do
  # Some db tasks require your app code to be loaded; they'll expect to find it here
  task :environment do
    require_relative 'app'
  end
end
