class CreateUserPaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :user_payment_methods do |t|
      t.references :user, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :kind, polymorphic: true
      t.timestamps
    end
  end
end
