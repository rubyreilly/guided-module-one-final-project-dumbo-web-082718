class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :date
      t.string :time
      t.string :link
      t.string :organizer
      t.integer :user_event_list_id
      t.string :location_name
      t.integer :location_id
    end
  end
end
