#!/usr/bin/env ruby

require "sinatra"
require "sequel"

get "/" do
  haml :blog
end
