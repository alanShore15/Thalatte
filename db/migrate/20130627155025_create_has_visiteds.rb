class CreateHasVisiteds < ActiveRecord::Migration
  def change
    create_table :has_visiteds do |t|
      t.integer :user_id
      t.integer :place_id

      t.timestamps
    end
  end
end
