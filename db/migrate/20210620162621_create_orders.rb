class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :token_company
      t.string :token_product
      t.references :payment_method, null: false, foreign_key: true
      t.string :token
      t.timestamps
    end
  end
end
