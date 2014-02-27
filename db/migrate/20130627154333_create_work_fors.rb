class CreateWorkFors < ActiveRecord::Migration
  def change
    create_table :work_fors do |t|
      t.integer :user_id
      t.integer :company_id
      t.date :from
      t.date :to

      t.timestamps
    end
  end
end
