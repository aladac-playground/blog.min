#!/usr/bin/env ruby
require "./lib/blog"

$config = Blog::Config.new

class Public < Sinatra::Base
  # The "Home" page, listing the posts
  get "/" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_page)
    haml :blog
  end
  
  # A particular sub-page view
  get "/page/:page_id" do
    @page = Blog::Page.select(params[:page_id])
    haml :page
  end
end

class Protected < Sinatra::Base
  # Use Rack simple auth and the configured username and password to authentificate
  use Rack::Auth::Basic do |$config.username, $config.password|
      [username, password] == [ admin_user, admin_pass ]
  end
  
  # The general dashboard location
  get "/" do
    haml :admin
  end
  
  get "/save_post" do
    Blog::Post.new(params[:title], params[:body])
  end
  
  # Post editor with live preview
  get "/edit_post" do
    haml :edit_post, :format => :html5
  end
  
  # List all posts allowing deletion and edition
  get "/posts_list" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_table)
    # If there are no more posts for the current page, redirect to the previous page
    if @posts.current_page_record_count == 0
      redirect "/admin/posts_list/#{params[:page].to_i - 1}" unless @posts.current_page == 1
    end
    haml :posts_list
  end
  
  # Delete a post by id
  get "/post_delete/:id" do
    Blog::Post.delete(params[:id])
    redirect request.referrer
  end
  
  # Generate a Markdown preview with syntax highlighting provided by CodeRay
  get "/preview" do
    Blog::Text.render(params[:preview])
  end
end
