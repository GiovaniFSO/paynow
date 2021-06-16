class ChageDefaultActivePaymenteMethod < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:payment_methods, :active, from: false, to: true)
  end
end
