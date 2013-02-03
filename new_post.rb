#!/usr/bin/env ruby

require "sequel"

DB = Sequel.sqlite("blog.db")

dataset = DB[:posts]


print "Give the post a title\nTitle: "

title=gets

print "Write what you want using Textile markup. \n Body:\n"

$/ = "."

body = STDIN.gets

dataset.insert(:title => title, :body => body, :created_at => Time.now)
