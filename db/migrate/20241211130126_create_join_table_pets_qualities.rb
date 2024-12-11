class CreateJoinTablePetsQualities < ActiveRecord::Migration[7.2]
  def change
    create_join_table :pets, :qualities do |t|
      # t.index [:pet_id, :quality_id]
      # t.index [:quality_id, :pet_id]
    end
  end
end
