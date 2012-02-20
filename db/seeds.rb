# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
User.create(:username=> "asdf", :fname=> "asdf", :lname =>"asdf", :snumber =>1234)
User.create(:username=> "asdf2", :fname =>"asdf2", :lname =>"asdf2", :snumber =>1111)
User.create(:username=> "asdf3", :fname =>"asdf", :lname =>"asdf", :snumber =>2222)
User.create(:username=> "asdf4", :fname =>"asdf2", :lname =>"asdf2", :snumber =>3333)
User.create(:username=> "asdf5", :fname =>"asdf3", :lname =>"asdfz", :snumber =>4444)
User.create(:username=> "asdf6", :fname =>"asdf3", :lname =>"asdfz", :snumber =>5555)
User.create(:username=> "asdf7", :fname =>"asdf4", :lname =>"asdfz", :snumber =>6666)
User.create(:username=> "asdf8", :fname =>"asdf5", :lname =>"asdfz", :snumber =>7777)
User.create(:username=> "asdf9", :fname =>"asdf3", :lname =>"asdfz", :snumber =>8888)
User.create(:username=> "asdf10",:fname =>"asdf6", :lname =>"asdf", :snumber =>9999)
User.create(:username=> "asdf11",:fname =>"asdf5", :lname =>"asdf", :snumber =>1212)
User.create(:username =>"asdf12",:fname=>"asdf", :lname =>"asdf", :snumber =>2323)
User.create(:username =>"asdf13",:fname =>"asdf6", :lname =>"asdf", :snumber =>3434)
User.create(:username =>"asdf14", :fname=> "asdf7", :lname =>"asdf", :snumber=> 4545)
User.create(:username =>"asdf15", :fname=> "asdf7", :lname =>"asdf", :snumber=> 5656)

