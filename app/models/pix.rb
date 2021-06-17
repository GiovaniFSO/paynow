class Pix < ApplicationRecord
  has_many :user_payment_methods, as: :kind

  validates :key, :bank_code, presence: true
  validates :key, length: { is: 20 }    
  validates :bank_code, length: { is: 3 }    
end
