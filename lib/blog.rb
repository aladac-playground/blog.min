require "sinatra"
require "sequel"
require "yaml"
require "redcarpet"
require "coderay"
require "nokogiri"

Sequel.extension :pagination

module Blog
  DB = Sequel.sqlite("db/blog.db")
  class Config
    def method_missing(method)
      method = method.to_s
      row = DB[:options].where(:name => method)
      row.first[:value] unless row.empty?
    end
  end

# ================
# = Page methods =
# ================
  class Page
    def self.all
      DB[:pages]
    end
    def self.select(arg)
      DB[:pages].where(:id => arg).first
    end
  end

# ================
# = Post methods =
# ================
  class Post
    def self.new(title,body)
      DB[:posts].insert(:title => title, :body => body)    
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
      doc = Nokogiri::HTML(html)
      p html
      doc.search("//pre").each do |pre|
        pre.search("//code[@class]").each do |code|
          pre.replace CodeRay.scan(code.text, code[:class]).div
        end
      end
      return doc.to_s
    end
    def self.render(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :fenced_code_blocks => true)  
      html = markdown.render(text)
      result = Blog::Text.highlight(html)
      return result  
    end
  end
  
end
