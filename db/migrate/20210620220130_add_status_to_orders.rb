class AddStatusToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :status, :integer, default: 1, null: false
  end
end
