class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :user_id
      t.decimal :longitude
      t.decimal :latitude
      t.string :name

      t.timestamps
    end
  end
end
