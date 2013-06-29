# Rakefile
require "gemoji"
load 'tasks/emoji.rake'
require "./lib/blog"

desc "load fixtures into DB (sample posts, sample pages)"
task :fixtures do 
  Blog::Fixtures.import
end