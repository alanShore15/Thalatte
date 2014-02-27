class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :user_id
      t.integer :connection_id
      t.string :connection_type

      t.timestamps
    end
  end
end
