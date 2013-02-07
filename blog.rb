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
    page = Blog::Page.select(params[:page_id])
    @title = page[:title]
    @body = page[:body]
    haml :page
  end
end

class Protected < Sinatra::Base
  # Use Rack simple auth and the configured username and password to authentificate
  use Rack::Auth::Basic do |username, password|
      [username, password] == [ $config.admin_user, $config.admin_pass ]
  end
  
  # The general dashboard location
  get "/" do
    haml :admin
  end
  
  get "/save_post" do
    Blog::Post.new(params[:title], params[:body])
  end
  
  # Post editor with live preview
  get "/post_edit" do
    if params[:id]
      @edit_form_action = :post_update
      @post = Blog::Post.select(params[:id])
    else
      @edit_form_aciton = :post_new
    end
    haml :post_edit, :format => :html5
  end
  
  # Update a post
  get "/post_update" do
    Blog::Post.update(params[:id], params[:title], params[:body])
  end
  
  # List all posts allowing deletion and edition
  get "/post_list" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_table)
    # If there are no more posts for the current page, redirect to the previous page
    if @posts.current_page_record_count == 0
      redirect "/admin/post_list/#{params[:page].to_i - 1}" unless @posts.current_page == 1
    end
    haml :post_list
  end

  # Create a post
  
  get "/post_new" do
    Blog::Post.new(params[:title],params[:body])
    redirect request.referrer
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
