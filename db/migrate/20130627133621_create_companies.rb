class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
