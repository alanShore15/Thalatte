class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|
      t.string :institute_name
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
