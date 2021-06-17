class UserPaymentMethod < ApplicationRecord
  belongs_to :user
  belongs_to :payment_method
  belongs_to :kind, polymorphic: true

  validates :kind_id, presence: true
end