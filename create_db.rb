#!/usr/bin/env ruby

require "sequel"

if File.exists?("blog.db")
  puts "blog.db already exists"
  exit 1
end

DB = Sequel.sqlite("blog.db")

DB.create_table :users do
  primary_key :id
  String :name, :unique => true, :null => false
  String :password, :null => false
  DateTime :created_at
  index :created_at
end

DB.create_table :posts do
  primary_key :id
  String :title, :unique => true, :null => false
  String :body, :null => false
  foreign_key :user_id, :users
  DateTime :created_at
  index :created_at
end
