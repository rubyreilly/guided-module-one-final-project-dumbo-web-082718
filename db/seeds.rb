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


all_data.map do |event|
  Event.find_or_create_by({name:event[:name],
    start:DateTime.parse(event[:date]+ " " +event[:time]),
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
