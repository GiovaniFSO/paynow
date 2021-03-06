class Product < ApplicationRecord
  has_paper_trail on: [:update]
  #PaperTrail.serializer.load(Product.first.versions.first.object)
  belongs_to :user
  belongs_to :user_payment_method
  has_many :orders, primary_key: :token, foreign_key: :token_product

  validates :name, :value, :user_payment_method_id, :discount, presence: true

  before_create :set_token
  
  private
  
  def set_token
    if self.token.blank?
      self.token = SecureRandom.hex(10)
      set_token if Product.exists?(token: token)
    end
  end
end