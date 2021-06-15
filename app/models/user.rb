class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :check_email

  belongs_to :company, optional: true

  def check_email 
    errors.add(:email, "não é válido") if ['@gmail', '@hotmail', '@outlook', '@uol', '@yahoo'].any?{ |not_valid| email.include?(not_valid) }
    company_domain = email.split('@').second.split('.').first
    first_from_company(company_domain)
  end       

  private

  def first_from_company(company_domain)
    return if self.company_id
    
    user = User.where('email like ?', "%#{company_domain}%").first
    self.company_id = user.blank?  ? nil : user.company_id
  end

end
