class CreateBoletos < ActiveRecord::Migration[6.1]
  def change
    create_table :boletos do |t|
      t.string :bank_code
      t.string :agency
      t.string :account

      t.timestamps
    end
  end
end
