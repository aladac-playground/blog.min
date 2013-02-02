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
