#!/usr/bin/env ruby
require "./lib/blog"

$config = Blog::Config.new

$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true)

class Public < Sinatra::Base
  get "/" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_page)
    haml :blog
  end
  get "/page/:page_id" do
    @page = Blog::Page.select(params[:page_id])
    haml :page
  end
end

class Protected < Sinatra::Base
  admin_user = $config.admin_user
  admin_pass = $config.admin_pass
  use Rack::Auth::Basic do |username, password|
      [username, password] == [ admin_user, admin_pass ]
  end
  
  get "/" do
    haml :admin
  end
  
  get "/save_post" do
    Blog::Post.new(params[:title], params[:body])
  end
  
  get "/posts_list" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_table)
    # If there are no more posts for the current page, redirect to the previous page
    if @posts.current_page_record_count == 0
      redirect "/admin/posts_list/#{params[:page].to_i - 1}" unless @posts.current_page == 1
    end
    haml :posts_list
  end

  get "/post_delete/:id" do
    Blog::Post.delete(params[:id])
    redirect request.referrer
  end
end
