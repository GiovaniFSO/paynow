class CreditCardDetail < ApplicationRecord
  has_many :order_details, as: :info

  validates :number, :name, :safe_code, presence: true
end
