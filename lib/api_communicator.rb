require 'rest-client'
require 'JSON'
require 'pry'

class ApiCommunicator
  attr_accessor :url

  def initialize(url)
    @url = url

  end

  def get_response
    data = RestClient.get(@url)
    data = JSON.parse(data)
  end
end


class ApiTranslator

  attr_accessor :data_array

  def initialize(data_array)
    @data_array=data_array
  end

  def translate_data
    @data_array = @data_array.map do |event|
      if event["venue"]
        {name: event["name"],
        date: event["local_date"],
        time: event["local_time"],
        link: event["link"],
        organizer: event["group"]["name"],
        location_name:event["venue"]["name"],
        location_address:event["venue"]["address_1"],
        location_city:event["venue"]["city"]}
      else
        {name: event["name"],
          date: event["local_date"],
          time: event["local_time"],
          link: event["link"],
          organizer: event["group"]["name"]}
      end
    end
  end
end
