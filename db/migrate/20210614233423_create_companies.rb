class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :cnpj
      t.string :name
      t.string :address
      t.string :email
      t.string :token
      t.integer :block

      t.timestamps
    end
  end
end
