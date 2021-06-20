class CreateCreditCardDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :credit_card_details do |t|
      t.string :number
      t.string :name
      t.string :safe_code

      t.timestamps
    end
  end
end
