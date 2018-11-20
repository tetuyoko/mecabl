lock '3.4.0'

set :application, 'mecabl'
set :repo_url, 'git@github.com:/mecabl.git'
set :branch, 'master'
set :deploy_to, "/var/www/#{fetch(:application)}"
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, false

# original define.
set :deploy_user, ENV['DEPLOY_USER'] || 'ubuntu'
set :deploy_ssh_keys, ENV['DEPLOY_SSH_KEYS'] || '~/.ssh/mecab-bl/mecab-bl.pem'

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system'
)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :keep_releases, 5

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles,      ->{ :app }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  # refs
  # https://github.com/capistrano/rails/issues/111#issuecomment-94151119
  task :fix_absent_manifest_bug do
    on roles(:web) do
      within release_path do  execute :touch,
        release_path.join('public',
                          fetch(:assets_prefix), 'manifest-fix.temp')
      end
    end
  end
  after :updating, 'deploy:fix_absent_manifest_bug'

  # setup は完全な database.yml, secretes.yml を持っている人間がやること
  namespace :setup do
    desc "deploy database.yml"
    task :database_yml do
      on roles(:app) do
        upload!('./config/database.yml', "#{shared_path}/config/database.yml")
      end
    end

    desc "deploy secrets.yml"
    task :secrets_yml do
      on roles(:app) do
        upload!('./config/secrets.yml', "#{shared_path}/config/secrets.yml")
      end
    end

    desc "upload ymls"
    task :default do
      invoke "deploy:setup:database_yml"
      invoke "deploy:setup:secrets_yml"
    end
  end
end

task setup: 'setup:default'
