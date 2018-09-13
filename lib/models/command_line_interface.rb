require 'pry'

class CommandLineInterface

  @@prompt = TTY::Prompt.new

  def greet
    puts "Welcome to Flatiron NY Event Search!"
  end

  def my_list(events)
    if events == "Your list is empty."
      return events
    else
      event_info= get_event_info(events)
    end
  end

  def find_event_by_date(date)
    event_options= Event.all.select do |event|
      event.date == date
    end
    if event_options ==[]
      puts "There are no events on this date."
    else
      event_options
    end
  end

  def get_event_info_short(events)
    event_info_short = events.map do |event|
      ["#{event.id} // #{event.name} // #{event.date} // #{event.time} // #{Location.find(event.location_id).city}"]

      ###########this is a string so it can't transfer attribute accessors##################
    end
  end

  def get_event_info(events)
    event_info = events.map do |event|
      [event.name,event.date,event.time,Location.find(event.location_id).city]
    end
  end


  def add_event(user_event_list,event_options)
    choices=[]
    letters="abcdefghijklmnopqrstuvwxyz"
    event_options.each_with_index do |event, index|
    choices <<{key: letters[index] , name: ["#{event.name} // #{event.date} // #{event.time} // #{Location.find(event.location_id).city}"], value: event }
    end
    # binding.pry
    event_choice = @@prompt.expand('Which event do you want to add?', choices)

    # event_choice = @@prompt.multi_select('Which event do you want to add?', choices)
    # event_options = get_event_info_short(event_options)
    # event_choice= @@prompt.multi_select("Which event do you want to add?", event_options)
    event_options.select do |event|
      # binding.pry
      if event==event_choice
        user_event_list.events<<event
      end
    end
    user_event_list.events
  end
  #
  # def add_event(user_event_list, event_options)
  #   event_names=[]
  #   event_options.each do |event|
  #     event_names<<event.name
  #   end
  #   event_choice= @@prompt.select("Which event do you want to add?", event_names)
  #   event_options.select do |event|
  #     if event.name==event_choice
  #       user_event_list.events<<event
  #     end
  #   end
  #   user_event_list.events
  # end



  def delete_event(user_event_list)
    events = user_event_list.events
    event_names=[]
    events.each do |event|
      event_names<<event.name
    end
    delete_choice_name= @@prompt.select("Which event do you want to delete?", event_names)
    events.select do |event|
      if event.name==delete_choice_name
        user_event_list.events.delete(event)
      end
    end
    user_event_list.events
  end

  def display_event_data(event)
    name = event.name
    # date = event.date
    date = date_converter(event.date)
    time = event.time
    # time = time_converter(event.time)
    organizer = event.organizer
    link = event.link
    location_name = Location.find(event.location_id).name
    location_address = Location.find(event.location_id).address
    location_city = Location.find(event.location_id).city
    puts name
    puts date
    puts time
    puts organizer
    puts location_name
    puts location_address
    puts location_city
    puts link
  end

  def time_converter(time)
  end

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
  end

  def gets_user_input

    puts "What is your name?"
    user_name = gets.chomp
    list_name = "#{user_name}'s Flatiron Event List"
    puts "Let's work on #{list_name}!"
    user_event_list = UserEventList.find_or_create_by({user_name:user_name,list_name:list_name})

    if user_event_list.events==[]
      my_events="Your list is empty."
    else
      my_events = user_event_list.events
    end

    input = ""

    until input=="EXIT"
      input = @@prompt.select("Select one:", ["MY LIST", "ADD EVENT", "DELETE EVENT", "NEW USER", "EXIT"])

      if input == "ADD EVENT"
        puts "Enter a date:"
        date=gets.chomp
        event_options= find_event_by_date(date)
        if event_options !=nil
          my_events=add_event(user_event_list,event_options)
        end

      elsif input == "MY LIST"
        if user_event_list.events==[]
          my_events= "You have no events yet."
          puts my_events
        else
          puts "----------------------------------------------"
          my_events.each do |event|
            display_event_data(event)
            puts "----------------------------------------------"
          end
        end

      elsif input == "DELETE EVENT"
        if user_event_list.events == []
          puts my_events
        else
          delete_event(user_event_list)
        end

      elsif input == "NEW USER"
        gets_user_input
      end
    end
  end
end
