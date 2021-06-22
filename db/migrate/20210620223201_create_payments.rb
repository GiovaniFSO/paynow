class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.datetime :date
      t.integer :status
      t.string :status_bank

      t.timestamps
    end
  end
end
