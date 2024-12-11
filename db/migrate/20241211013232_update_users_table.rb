class UpdateUsersTable < ActiveRecord::Migration[7.2]
  def change
    remove_columns :users, :apellido, :edad, :sexo, :receive_updates, if_exists: true
    add_column :users, :phone, :string
    change_column_default :users, :role, from: nil, to: 0
  end
end
