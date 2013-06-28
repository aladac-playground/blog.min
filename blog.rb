#!/usr/bin/env ruby
require "./lib/blog"


$config = Blog::Config.new
require "better_errors"
require "binding_of_caller"
configure :development do
  use BetterErrors::Middleware
end


class Public < Sinatra::Base

  # The "Home" page, listing the posts
  get "/" do
    params[:page] ? page = params[:page].to_i : page = 1
    @posts = Blog::Post.page(page, $config.posts_per_page)
    haml :blog
  end
  
  # Display a specific post
  get "/post/:post_id" do
    @post = Blog::Post.select(params[:post_id])
    redirect "/" if ! @post
    haml :post
  end
  
  # A particular sub-page view
  get "/page/:page" do
    @page = Blog::Page.select(params[:page]) or @page = Blog::Page.title(params[:page])
    redirect "/" if @page.nil?
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

  # Post editor with live preview
  get "/post_edit" do
    if params[:id]
      @edit_form_action = "/admin/post_update"
      @post = Blog::Post.select(params[:id])
    else
      @edit_form_action = "/admin/post_new"
    end
    haml :post_edit, :format => :html5
  end
  
  # Update a post
  get "/post_update" do
    Blog::Post.update(params[:id], params[:title], params[:body])
    redirect "/admin/post_list"
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
    redirect "/admin/post_list"
  end
  
  # Delete a post by id
  get "/post_delete/:id" do
    Blog::Post.delete(params[:id])
    redirect request.referrer
  end

  # Page editor with live preview
  get "/page_edit" do
    if params[:id]
      @edit_form_action = "/admin/page_update"
      @page = Blog::Page.select(params[:id])
    else
      @edit_form_action = "/admin/page_new"
    end
    haml :page_edit, :format => :html5
  end
  
  # Update a page
  get "/page_update" do
    Blog::Page.update(params[:id], params[:title], params[:body])
    redirect "/admin/page_list"
  end
  
  # List all pages allowing deletion and edition
  get "/page_list" do
    params[:page] ? page = params[:page].to_i : page = 1
    @pages = Blog::Page.page(page, $config.pages_per_table)
    # If there are no more pages for the current page, redirect to the previous page
    if @pages.current_page_record_count == 0
      redirect "/admin/page_list/#{params[:page].to_i - 1}" unless @pages.current_page == 1
    end
    haml :page_list
  end

  # Create a page
  
  get "/page_new" do
    Blog::Page.new(params[:title],params[:body])
    redirect "/admin/page_list"
  end
  
  # Delete a page by id
  get "/page_delete/:id" do
    Blog::Page.delete(params[:id])
    redirect request.referrer
  end


  
  # Generate a Markdown preview with syntax highlighting provided by CodeRay
  get "/preview" do
    preview = Blog::Text.sanitize(params[:preview])
    Blog::Text.render(preview)
  end
end
