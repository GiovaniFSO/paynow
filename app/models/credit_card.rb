class CreditCard < ApplicationRecord
  has_many :user_payment_methods, as: :kind  
end
