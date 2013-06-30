# blog.min

**blog.min** is a minimalistic blog created for one purpose only. To quickly post short articles with syntax highlighted code.
It's devoid of any features like mutli-user support, social integration (other than share on Twitter), tags. 

If you want an actual blog and ruby is your thing consider using [Enki](https://github.com/xaviershay/enki)

## Idea
All started with me being semi-satisfied with what other blogging platforms had to offer.
I wanted something realy simple with syntax highlighting. Something that I could easily change on a whim.
That's how *blog.min* was born.

## Gems
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

## Best practices
While writing *blog.min* I used many of trendy industry best practices including but not limited to:
* Make it up as you go
* NoQA
* Caffeine Driven Development
* Overcommiting
* Undecommiting
