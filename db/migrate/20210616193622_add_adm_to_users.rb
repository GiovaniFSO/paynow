class AddAdmToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :adm, :integer, default: 0, null: false
  end
end
