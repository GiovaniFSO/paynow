class Company < ApplicationRecord
  has_many :users  
  
  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.hex(10)
    set_token if Company.exists?(token: token)
  end
end