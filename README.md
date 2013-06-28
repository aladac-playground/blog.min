# blog.min
## The idea
All started with me being semi-satisfied with what other blogging platforms had to offer.
I wanted something realy simple with syntax highlighting. Something that I could easily change on a whim.
That's how *blog.min* was born.

## The gems
This sucker uses several nifty gems to make it work:

```ruby
gem "sinatra"     # As the web micro-framework
gem "gemoji"      # provider of emoji
gem "sequel"      # ORM which in this case is an overkill 
gem "haml"        # template engine
gem "sqlite3"     # DB driver
gem "redcarpet"   # Markdown producer
gem "nokogiri"    # HTML wrangler
gem "coderay"     # Syntax Highlighter
gem "unicorn"     # The Web Reactor
gem "sanitize"    # HTML Sanitizer
```

For ease of debugging I also use:

```ruby
gem "better_errors", :group => :development
gem "binding_of_caller", :group => :development
```
