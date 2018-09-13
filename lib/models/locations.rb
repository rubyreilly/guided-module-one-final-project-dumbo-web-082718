class Location < ActiveRecord::Base
  has_many :events
  has_many :user_event_lists, through: :events
end
