class CreateStudyAts < ActiveRecord::Migration
  def change
    create_table :study_ats do |t|
      t.integer :user_id
      t.integer :institute_id
      t.integer :passing_year
      t.string :major

      t.timestamps
    end
  end
end
