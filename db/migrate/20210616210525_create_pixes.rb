class CreatePixes < ActiveRecord::Migration[6.1]
  def change
    create_table :pixes do |t|
      t.string :key
      t.string :bank_code

      t.timestamps
    end
  end
end
