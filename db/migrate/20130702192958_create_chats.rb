class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.string :message

      t.timestamps
    end
  end
end
