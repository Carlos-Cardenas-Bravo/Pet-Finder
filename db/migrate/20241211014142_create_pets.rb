class CreatePets < ActiveRecord::Migration[7.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :nickname
      t.boolean :is_nickname
      t.string :pet_type
      t.text :description
      t.date :found_on
      t.string :city
      t.text :qualities
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
