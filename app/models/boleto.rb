class Boleto < ApplicationRecord
  has_many :user_payment_methods, as: :kind  

  validates :agency, :account, :bank_code, presence: true
  validates :bank_code, length: { is: 3 }    
end
