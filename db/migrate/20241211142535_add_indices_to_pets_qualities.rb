class AddIndicesToPetsQualities < ActiveRecord::Migration[7.2]
  def change
    add_index :pets_qualities, [:pet_id, :quality_id], unique: true
    add_index :pets_qualities, [:quality_id, :pet_id], unique: true
  end
end
