class AddPositionToWorkFor < ActiveRecord::Migration
  def change
    add_column :work_fors, :position, :string
  end
end
