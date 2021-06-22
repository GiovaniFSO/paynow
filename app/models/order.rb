class Order < ApplicationRecord
  enum status: {pendente: 1, rejeitada: 2, aprovada: 5}  
  
  belongs_to :payment_method
  belongs_to :company, primary_key: 'token', foreign_key: 'token_company'
  belongs_to :product, primary_key: 'token', foreign_key: 'token_product'
  belongs_to :customer, primary_key: 'token', foreign_key: 'token_customer'
  has_many :order_details
  has_many :payments

  before_create :set_prices
  before_create :set_token

  scope :from_date, ->(date) { where(created_at: date...) if date.present? }
  scope :from_payment_method, ->(payment_method) { where(payment_method_id: payment_method) if payment_method.present? }

  private

  def set_prices
    self.original_price = self.product.value
    self.final_price = self.original_price - self.product.discount*100/self.original_price
  end
  
  def set_token
    self.token = SecureRandom.hex(10)
    set_token if Customer.exists?(token: token)
  end
end
