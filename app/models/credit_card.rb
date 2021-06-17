class CreditCard < ApplicationRecord
  has_many :user_payment_methods, as: :kind  

  validates :account, length: {is: 20}
end
