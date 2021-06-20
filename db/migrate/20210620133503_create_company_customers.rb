class CreateCompanyCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :company_customers do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
