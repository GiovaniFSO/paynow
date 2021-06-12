class PaymentMethod < ApplicationRecord
  enum kind: {boleto: 1, credit_card: 2, pix: 3}  
  has_one_attached :icon, dependent: :destroy  

  validates :fee, :name, :max_fee, :kind,  presence: true
end
