app_path = "/var/www/mecabl"
shared_path = '/var/www/mecabl/shared'
working_directory "#{app_path}/current"

# refs https://github.com/herokaijp/devcenter/wiki/Rails-unicorn
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30

listen      '/var/www/mecabl/shared/tmp/sockets/unicorn.sock', backlog: 64
pid         File.expand_path('tmp/pids/unicorn.pid', shared_path)
stderr_path File.expand_path('log/unicorn_err.log', shared_path)
stdout_path File.expand_path('log/unicorn.log', shared_path)

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
