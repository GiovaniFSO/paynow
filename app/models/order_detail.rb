class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :info, polymorphic: true
end
