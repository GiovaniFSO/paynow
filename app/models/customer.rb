class Customer < ApplicationRecord
  has_many :company_customers  
  has_many :companies, through: :company_customers

  before_validation :set_token
  
  validates :name, :cpf,  presence: true
  validates :cpf, length: { is: 11 }, numericality: true 
  
  private
  
  def set_token
    self.token = SecureRandom.hex(10)
    set_token if Customer.exists?(token: token)
  end
end
