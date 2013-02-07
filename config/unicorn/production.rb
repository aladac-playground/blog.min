app_name "minblog"
deploy_path "/apps/#{app_name}"
app_dir "#{deploy_path}/current"
worker_processes 2
working_directory app_dir

# Load app into the master before forking workers for super-fast
# worker spawn times
preload_app true

# nuke workers after 30 seconds (60 is the default)
timeout 30

# listen on a Unix domain socket and/or a TCP port,

#listen 8080 # listen to port 8080 on all TCP interfaces
#listen "127.0.0.1:8080"  # listen to port 8080 on the loopback interface
listen "#{app_dir}/tmp/sockets/#{app_name}.socket"

pid "#{app_dir}/tmp/pids/unicorn.pid"
stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"
