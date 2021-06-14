class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.integer :kind, default: 0, null: false
      t.string :name, null: false
      t.decimal :fee, null: false
      t.decimal :max_fee, null: false
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
