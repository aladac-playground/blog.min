#!/usr/bin/env ruby

require "sequel"

if File.exists?("db/blog.db")
  puts "blog.db already exists"
  exit 1
end

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