class Product < ApplicationRecord
  belongs_to :user
  belongs_to :user_payment_method
end
