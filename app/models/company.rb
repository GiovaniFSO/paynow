class Company < ApplicationRecord
  enum block: {desbloqueado: 1, bloqueado: 2}  
  has_many :users  
  has_many :company_customers
  has_many :customers, through: :company_customers
  has_many :orders, primary_key: :token, foreign_key: :token_company
  
  validates :cnpj, :name, :address, :email, presence: true
  validates :cnpj, length: { is: 14 }, numericality: true, uniqueness: true  

  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.hex(10)
    set_token if Company.exists?(token: token)
  end
end