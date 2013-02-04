#!/usr/bin/env ruby

require "sinatra"
require "sequel"
require "yaml"
require "redcarpet"
require "coderay"
require "nokogiri"

Sequel.extension :pagination


DB = Sequel.sqlite("blog.db")

$config = YAML.load_file("blog.yml")

$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true)

def hilite(html)
  doc = Nokogiri::HTML(html)
  doc.search("//pre").each do |pre|
    pre.search("//code").each do |code|
      pre.replace CodeRay.scan(code.text, code[:class]).div
    end
  end
  return doc.to_s
end

class Public < Sinatra::Base
  get "/" do
    params[:page] ? page = params[:page].to_i : page = 1
    @title = $config["title"]
    @posts = DB[:posts].reverse_order(:created_at).paginate(page, $config["posts_per_page"])
    haml :blog
  end
end

class Protected < Sinatra::Base
  admin_user = $config["admin_user"]
  admin_pass = $config["admin_pass"]
  use Rack::Auth::Basic do |username, password|
      [username, password] == [ admin_user, admin_pass ]
  end
  get "/" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = DB[:posts].reverse_order(:created_at).paginate(page, 8)
    # If there are no more posts for the current page, redirect to the previous page
    if @posts.current_page_record_count == 0
      redirect "/admin?page=#{params[:page].to_i - 1}" unless @posts.current_page == 1
    end
    @title = $config["title"]
    haml :posts_list
  end

  get "/post_delete/:id" do
    DB[:posts].where(:id => params[:id]).delete
    redirect request.referrer
  end
end
