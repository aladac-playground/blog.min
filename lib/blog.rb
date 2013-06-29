require "sinatra"
require "sequel"
require "sqlite3"
require "yaml"
require "redcarpet"
require "coderay"
require "nokogiri"
require "sanitize"

Sequel.extension :pagination

if ! File.exists?("db/blog.db")
  # If the db file doesn't exist create it create tables
  DB = Sequel.sqlite("db/blog.db")

  DB.create_table :posts do
    primary_key :id
    String :title, :null => false
    String :body, :null => false
    DateTime :created_at
    index :created_at
  end

  DB.create_table :options do
    String :name, :null => false, :primary_key => true
    String :value, :null => false
  end

  DB.create_table :pages do
    primary_key :id
    String :title, :null => false
    String :body, :null => false
    DateTime :created_at
    index :created_at
  end

  # ... load the default config into DB
  dataset = DB[:options]

  config = YAML.load_file("blog.yml")
  config.each_pair do |name, value|
      dataset.insert(:name => name, :value => value)
  end
end

module Blog
  DB = Sequel.sqlite("db/blog.db")
  class Config
    def method_missing(method)
      method = method.to_s
      row = DB[:options].where(:name => method)
      row.first[:value] unless row.empty?
    end
  end
  
# ============
# = Fixtures =
# ============
  class Fixtures
    def self.import(posts=10)
      dataset = DB[:posts]
      posts.times do |i|
        dataset.insert(:title => "Title #{i}", :body => "Lorem ipsum dolor sit amet, \n\n```ruby\nrequire 'time'\nputs 'Hello World!'\n```\nconsectetur adipisicing elit, 
        sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip 
          ex ea commodo consequat. \n\n```ruby \nrequire 'time'\nputs 'Hello World!'\n```\n Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
          :created_at => Time.now)
      end
      dataset = DB[:pages]
      dataset.insert(:title => "About Me", :body => "This is a page about me ")
      dataset.insert(:title => "Contact", :body => "You can contact me at")
    end
  end
  
# ================
# = Page methods =
# ================
  class Page
    def self.new(title,body)
      body = Blog::Text.sanitize(body)  
      DB[:pages].insert(:title => title, :body => body, :created_at => Time.now)    
    end
    def self.all
      DB[:pages]
    end
    def self.select(arg)
      DB[:pages].where(:id => arg).first
    end
    def self.title(arg)
      DB[:pages].where(:title => arg).first
    end
    def self.delete(arg)
      DB[:pages].where(:id => arg).delete
    end
    def self.update(post_id, title, body)
      DB[:pages].where(:id => post_id).update(:body => body, :title => title)
    end
    def self.page(current_page, pages_per_page)
      Blog::Page.all.paginate(current_page.to_i, pages_per_page.to_i)
    end
  end

# ================
# = Post methods =
# ================
  class Post
    def self.new(title,body)
      body = Blog::Text.sanitize(body)  
      DB[:posts].insert(:title => title, :body => body, :created_at => Time.now)    
    end
    def self.all
      DB[:posts].reverse_order(:created_at)    
    end
    def self.delete(arg)
      DB[:posts].where(:id => arg).delete
    end
    def self.page(current_page, posts_per_page)
      Blog::Post.all.paginate(current_page.to_i, posts_per_page.to_i)
    end
    def self.select(post_id)
      post = DB[:posts].where(:id => post_id)
      post.empty? ? nil : post.first
    end
    def self.update(post_id, title, body)
      DB[:posts].where(:id => post_id).update(:body => body, :title => title)
    end
  end
  
# ======================================================================
# = Text related stuff - for now just syntax highlighting with coderay =
# ======================================================================
  class Text
    def self.highlight(html)
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      doc.search("pre").each do |pre|
        pre.search("code[@class]").each do |code|
          pre.replace CodeRay.scan(code.text, code[:class]).div
        end
      end
      return doc.to_s
    end
    def self.sanitize(html)
      Sanitize.clean(html, :elements => %w[ a code pre li ul ol h1 h2 h3 p div iframe ],
                     :attributes => { 'all' => %w[ id class name value ] },
                     :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}})
    end
    def self.links(html)
      doc = Nokogiri::HTML::DocumentFragment.parse(html)
      doc.search("a").each do |anchor|
        if anchor['href'] =~ /^http/
          anchor['target'] = '_blank'
        end
      end
      return doc.to_s
    end
    def self.render(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true)
      text = Blog::Text.emojify(text)  
      html = markdown.render(text)
      result = Blog::Text.highlight(html)
      result = Blog::Text.links(result)
      return result  
    end
    def self.emojify(text)
      text.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        if Blog::Emoji.names.include?($1)
          "<img alt='" + $1 + "' height='20' src='/images/emoji/#{$1}.png' style='vertical-align:middle' width='20' />"
        else
          match
        end
      end
    end
  end
  class Emoji
    def self.names
      Dir.new('public/images/emoji').grep(/png$/).each do |emoji|
        emoji.gsub!(/.png$/,"")
      end
    end
  end
end
