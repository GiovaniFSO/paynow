class AddTokenCustomerToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :token_customer, :string
  end
end
