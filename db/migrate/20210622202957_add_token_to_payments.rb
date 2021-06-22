class AddTokenToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :token, :string
  end
end
