# frozen_string_literal: true

require 'fileutils'

DEPLOY_TO = File.expand_path(ENV.fetch('DEPLOY_HOME', '/var/api'))

# Unicorn server process id file
UNICORN_PID = '/tmp/pid/unicorn.pid'

# Server socket
UNICORN_SOCKET = File.expand_path(ENV.fetch('UNICORN_SOCKET', "#{DEPLOY_TO}/tmp/unicorn.sock"))

[UNICORN_PID, UNICORN_SOCKET].each do |path|
  FileUtils.mkdir_p(File.dirname(path))
end

# Preload application code before forking worker processes.
preload_app true

timeout 60

# Location of the socket, to appear in an NGINX upstream configuration
listen UNICORN_SOCKET, backlog: 64

# Where to store the pid file for the server process.
pid UNICORN_PID

ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile')

GC.copy_on_write_friendly = true if GC.respond_to? :copy_on_write_friendly=

before_fork do |server, _worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # When the signal is sent to the old server process to start up a new
  # master process with the new code release, the old server's pidfile
  # is suffixed with ".oldbin".
  old_pid = Pathname.new("#{UNICORN_PID}.oldbin")
  if old_pid.exist? && server.pid != old_pid
    begin
      Process.kill('QUIT', old_pid.read.to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      LOG.info("#{old_pid.read} has already shutdown")
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['scarif'])
end

worker_processes 4
