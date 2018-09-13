class CreateUserEventLists < ActiveRecord::Migration[5.0]
  def change
    create_table :user_event_lists do |t|
      t.string :user_name
      t.string :list_name
    end
  end
end
