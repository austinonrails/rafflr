default_run_options[:pty] = true

# be sure to change these
set :github_user, 'bdeterling'
set :github_application, "rafflr"
set :user, 'brian'
set :domain, 'slice'
set :application, 'rafflr'

# the rest should be good
set :repository,  "git@github.com:#{github_user}/#{github_application}.git"
set :deploy_to, "/var/apps/#{application}" 
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

server domain, :app, :web

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end
