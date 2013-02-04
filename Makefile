clean:
	rm -f blog.db
	./create_db.rb
	./fixtures.rb