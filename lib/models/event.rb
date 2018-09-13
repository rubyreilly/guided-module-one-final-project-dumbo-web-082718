class Event < ActiveRecord::Base
  belongs_to :user_event_lists
  belongs_to :locations
end
