class Order < ApplicationRecord
  belongs_to :payment_method
  has_many :order_details
  belongs_to :company, primary_key: 'token', foreign_key: 'token_company'
  belongs_to :product, primary_key: 'token', foreign_key: 'token_product'
end
