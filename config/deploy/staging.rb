set :stage, :staging
set :rails_env, "staging"

server 'ubuntu@52.193.142.113', roles: %w(web app db)
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :ssh_options, {
  keys: fetch(:deploy_ssh_keys),
  forward_agent: true,
  auth_methods: %w(publickey)
}
