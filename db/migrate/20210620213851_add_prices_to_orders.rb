class AddPricesToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :original_price, :decimal
    add_column :orders, :final_price, :decimal
  end
end
