class AddCityRefToPets < ActiveRecord::Migration[7.2]
  def change
    add_reference :pets, :city, foreign_key: true
    remove_column :pets, :city, :string
  end
end
