class BoletoDetail < ApplicationRecord
  has_many :order_details, as: :info
end
