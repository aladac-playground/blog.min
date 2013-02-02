#!/usr/bin/env ruby

require "sinatra"
require "sequel"
require "yaml"

Sequel.extension :pagination


DB = Sequel.sqlite("blog.db")

config = YAML.load_file("blog.yml")

get "/" do
  params[:page] ? page = params[:page].to_i : page = 1
  @title = config["title"]
  @posts = DB[:posts].reverse_order(:created_at).paginate(page, config["posts_per_page"])
  haml :blog
end

get "/admin" do
  params[:page] ? page = params[:page].to_i : page = 1
  @posts = DB[:posts].reverse_order(:created_at).paginate(page, 8)
  @title = config["title"]
  haml :posts_list
end

get "/admin/post_delete/:id" do
  DB[:posts].where(:id => params[:id]).delete
  redirect request.referrer
end
