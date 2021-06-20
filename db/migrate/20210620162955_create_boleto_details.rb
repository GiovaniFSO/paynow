class CreateBoletoDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :boleto_details do |t|
      t.string :address

      t.timestamps
    end
  end
end
