class PaymentMethod < ApplicationRecord
  enum kind: {boleto: 1, credit_card: 2, pix: 3}  

  validates :fee, :name, :max_fee, :kind,  presence: true
end
