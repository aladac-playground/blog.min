#config.ru

require './blog'

run Rack::URLMap.new({
  "/" => Public,
  "/admin" => Protected
})
