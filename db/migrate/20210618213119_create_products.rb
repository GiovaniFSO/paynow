class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.decimal :value
      t.decimal :discount
      t.references :user_payment_method, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
