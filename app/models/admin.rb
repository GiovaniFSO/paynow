class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :email_valid

  def email_valid
    errors.add(:email, "não é válido") unless email.include?('@paynow.com.br') 
  end
end
