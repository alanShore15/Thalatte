class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :auth_token
      t.date :dob
      t.string :maretial_status
      t.string :gender
      t.string :fb_id
      t.string :linkedin_id

      t.timestamps
    end
  end
end
