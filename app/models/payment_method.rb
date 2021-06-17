class PaymentMethod < ApplicationRecord
  enum kind: {boleto: 1, credit_card: 2, pix: 3}  
  has_one_attached :icon, dependent: :destroy  
  has_many :user_payment_methods

  validates :fee, :name, :max_fee, :kind,  presence: true
  validates :fee, :max_fee, numericality: true
end
