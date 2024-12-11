class AddPetTypeToPets < ActiveRecord::Migration[7.2]
  def change
    remove_column :pets, :pet_type, :string
    add_reference :pets, :pet_type, foreign_key: true
  end
end
