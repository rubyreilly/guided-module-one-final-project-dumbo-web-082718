require 'pry'
require 'colorize'
require 'artii'

class CommandLineInterface

  @@prompt = TTY::Prompt.new

  def greet
    puts
    a = Artii::Base.new
    puts 'FLATIRON SCHOOL NY'.colorize(:light_magenta)
    puts a.asciify('EVENT LISTER').colorize(:light_cyan)
    # puts "Welcome to the Flatiron School NY Event List App!".colorize(:light_cyan)
    puts
  end


  def add_event(user_event_list,event_options)
    choices=[]
    event_options.each do |event|
      choices <<{name: ["#{event.name} // #{event.start.strftime("%B %d, %Y")} // #{Location.find(event.location_id).city}"], value: event }
    end
    event_choice = @@prompt.select('Which event do you want to add?'.colorize(:light_red), [choices, "NONE OF THE ABOVE"] )
    if event_choice == "NONE OF THE ABOVE"
      return user_event_list.events
    else
      event_options.select do |event|
        if event==event_choice
          user_event_list.events<<event
        end
      end
      user_event_list.events.uniq
    end
  end

  def delete_event(user_event_list)
    events = user_event_list.events
    choices=[]
    events.each do |event|
      choices <<{name: ["#{event.name} // #{event.start.strftime("%B %d, %Y")} // #{Location.find(event.location_id).city}"], value: event }
    end
    event_choice = @@prompt.select('Which event do you want to delete?'.colorize(:light_red), [choices, "NONE OF THE ABOVE"])
    if event_choice == "NONE OF THE ABOVE"
      return user_event_list.events
    else
      events.select do |event|
        if event==event_choice
          user_event_list.events.delete(event)
        end
      end
      user_event_list.events
    end
  end

  def display_event_data(event)
    name = event.name
    start = event.start.strftime("%B %d, %Y")
    organizer = event.organizer
    link = event.link
    location_name = Location.find(event.location_id).name
    location_address = Location.find(event.location_id).address
    location_city = Location.find(event.location_id).city
    puts name.colorize(:light_magenta)
    puts start
    puts organizer.colorize(:light_white)
    if location_name!=nil
      puts location_name.colorize(:light_white)
      puts location_address.colorize(:light_white)
      puts location_city.colorize(:light_white)
    end
    puts link.colorize(:light_cyan)
  end

  def find_event_by_month(month)
    event_options= Event.all.select do |event|
      event.start.strftime("%B %d, %Y").split.first== month.capitalize
    end
    if event_options ==[]
      puts
      puts "There are no events listed for this month.".colorize(:light_magenta)
      puts
    else
      event_options
    end
  end

  def select_month
    months = ["JANUARY","FEBRUARY", "MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"]
    month_choice = @@prompt.select('WHICH MONTH?'.colorize(:light_red), [months, "NONE OF THE ABOVE"])
  end

  def select_user
    user_names = UserEventList.all.map do |user|
      user.user_name
    end
    input = @@prompt.select("CREATE NEW USER or SELECT EXISTING USER:".colorize(:light_red), ["CREATE NEW USER", user_names])
    if input== "CREATE NEW USER"
      puts
      puts "What is your name?".colorize(:light_red)
      user_name = gets.chomp
    else
      user_name=user_names.select do |user|
        user == input
      end
      user_name = user_name[0]
    end
    puts
    puts "Hello #{user_name}!".colorize(:light_magenta)
    puts
    list_name = "#{user_name}'s Flatiron Event List"
    puts "Let's work on #{list_name}!".colorize(:light_yellow)
    puts
    user_event_list = UserEventList.find_or_create_by({user_name:user_name,list_name:list_name})
  end


  def gets_user_input
    user_event_list = select_user

    if user_event_list.events==[]
      my_events="Your list is empty.".colorize(:light_magenta)
    else
      my_events = user_event_list.events
    end

    input = ""

    until input=="EXIT"
      input = @@prompt.select("CHOOSE A COMMAND:".colorize(:light_red), ["MY LIST", "ADD EVENT", "DELETE EVENT", "EXIT"])

      if input == "ADD EVENT"
        month = select_month
        if month != "NONE OF THE ABOVE"
          event_options = find_event_by_month(month)
        end
        if event_options !=nil
          my_events=add_event(user_event_list,event_options)
        end

      elsif input == "MY LIST"
        if user_event_list.events==[]
          my_events= "You don't have any events yet.".colorize(:light_magenta)
          puts
          puts my_events
          puts
        else
          puts
          puts "#{user_event_list.list_name}:".colorize(:light_yellow)
          puts
          puts "----------------------------------------------".colorize(:light_blue)
          my_events.each do |event|
            display_event_data(event)
            puts "----------------------------------------------".colorize(:light_blue)
          end
          puts
          puts "(cmd + double click link to see event page on meetup.com!)".colorize(:light_white)
          puts
        end

      elsif input == "DELETE EVENT"
        if user_event_list.events == []
          puts
          puts my_events
          puts
        else
          delete_event(user_event_list)
        end

      end
    end
  end
end
