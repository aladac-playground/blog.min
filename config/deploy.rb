set :application, "minblog"
set :repository,  "git@sazabi.pl:chi/minblog.git"

set :rvm_type, :system

set :user, "deploy"
set :use_sudo, false

set :deploy_to, "/apps/#{application}"

# sample

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "sazabi.pl"                          # Your HTTP server, Apache/etc
role :app, "sazabi.pl"                          # This may be the same as your `Web` server
role :db,  "sazabi.pl", :primary => true # This is where Rails migrations will run
role :db,  "sazabi.pl"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

set :shared_assets, [ "db" ]

before "deploy:restart" do 
  prepare.link_shared
end

after "deploy:setup" do
  prepare.setup_shared
end


namespace :prepare do
  # task :db do
  #   run "cd #{deploy_to}/current/; bundle exec ruby create_db.rb"
  # end
  # task :db_load do
  #   run "cd #{deploy_to}/current/; bundle exec ruby fixtures.rb"
  # end
  desc "Setup additional shared paths"
  task :setup_shared do 
    shared_assets.each do |link|
      run "mkdir -p #{shared_path}/#{link}"
    end
  end

  desc "Linking shared stuff to release dir"
  task :link_shared do
    shared_assets.each do |link| 
      run "ln -nfs #{shared_path}/#{link} #{release_path}/#{link}" 
    end
  end
end

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano-unicorn'