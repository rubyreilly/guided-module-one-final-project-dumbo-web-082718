# Add seed data here. Seed your database with `rake db:seed`
require_relative '../config/environment'
require_relative '../lib/api_communicator.rb'

dumbo_url='http://api.meetup.com/Access-Labs-Coding-Community/events'
manhattan_url='http://api.meetup.com/Flatiron-School-Presents/events'

dumbo_api = ApiCommunicator.new(dumbo_url)
dumbo_api=dumbo_api.get_response

dumbo_data=ApiTranslator.new(dumbo_api)
dumbo_data=dumbo_data.translate_data

manhattan_api = ApiCommunicator.new(manhattan_url)
manhattan_api=manhattan_api.get_response

manhattan_data=ApiTranslator.new(manhattan_api)
manhattan_data=manhattan_data.translate_data

all_data= dumbo_data + manhattan_data

def date_converter(date)
  year = date[0..3]
  month= date[5..6]
  day = date[8..9]
  months_hash={"January"=>"01","February"=>"02","March"=>"03",
    "April"=>"04","May"=>"05","June"=>"06",
    "July"=>"07","August"=>"08","September"=>"09",
    "October"=>"10","November"=>"11","December"=>"12"}
  month = months_hash.find do |word,num|
    num==month
  end
  month = month[0]
  date = "#{month} #{day}, #{year}"
  binding.pry
end

all_data.map do |event|
  Event.find_or_create_by({name:event[:name],
    date:date_converter(event[:date]),
    time:event[:time],
    link:event[:link],
    organizer:event[:organizer],
    location_name:event[:location_name]})
end

all_data.map do |event|
  Location.find_or_create_by({name:event[:location_name],
    address: event[:location_address],
    city: event[:location_city]})
end

Location.all.map do |location|
  Event.all.each do |event|
    if event.location_name == location.name
      location.events<<event
    end
  end
end
