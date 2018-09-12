require_relative '../config/environment'
require_relative '../lib/api_communicator.rb'
# require_relative '../db/seeds.rb'


puts "What is your name?"
user_name= gets.chomp
list_name="#{user_name}'s Flatiron Event List"
puts "Add to #{list_name}"

puts Event.all
# user = UserEventList.create({user_name:user_name,list_name:list_name})
#
# puts Event.all
