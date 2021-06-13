class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :email_valid

  def email_valid 
    errors.add(:email, "não é válido") if ['@gmail', '@hotmail', '@outlook', '@uol', '@yahoo'].any?{ |not_valid| email.include?(not_valid) }
  end       
end
