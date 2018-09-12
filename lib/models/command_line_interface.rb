require 'pry'

class CommandLineInterface

  @@prompt = TTY::Prompt.new

  def greet
    puts "Welcome to Flatiron NY Event Search!"
  end

  # def new_user
  #   puts "What is your name?"
  #   user_name = gets.chomp
  #   list_name = "#{user_name}'s Flatiron Event List"
  #   puts "Let's work on #{list_name}!"
  #   user_event_list = UserEventList.find_or_create_by({user_name:user_name,list_name:list_name})
  # end

  def my_list(events)
    if events == "You have no events yet."
      return events
    else
      event_names = events.map do |event|
        event.name
      end
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

  def add_event(user_event_list,event_options)
    event_names=[]
    event_options.each do |event|
      event_names<<event.name
    end
    event_choice_name= @@prompt.select("Which event do you want to add?", event_names)
    event_options.select do |event|
      if event.name==event_choice_name
        user_event_list.events<<event
      end
    end
    user_event_list.events
  end

  def delete_event
  end


  def gets_user_input

    puts "What is your name?"
    user_name = gets.chomp
    list_name = "#{user_name}'s Flatiron Event List"
    puts "Let's work on #{list_name}!"
    user_event_list = UserEventList.find_or_create_by({user_name:user_name,list_name:list_name})

    if user_event_list.events==[]
      my_events="You have no events yet."
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
        my_event_names = my_list(my_events)
        puts my_event_names

      elsif input == "DELETE EVENT"
        delete_event

      elsif input == "NEW USER"
        gets_user_input
      end
    end
  end
end
