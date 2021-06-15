class ChangeDefaultBlockCompanies < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:companies, :block, from: nil, to: 1)
  end
end
