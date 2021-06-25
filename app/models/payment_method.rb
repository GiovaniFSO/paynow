class PaymentMethod < ApplicationRecord
  enum kind: {boleto: 1, credit_card: 2, pix: 3}  
  has_one_attached :icon, dependent: :destroy  
  has_many :user_payment_methods

  validates :fee, :name, :max_fee, :kind,  presence: true
  validates :fee, :max_fee, numericality: true

  before_create :set_icon

  def bank_method
    "#{name} - #{kind.titleize}"
  end
  
  private

  def set_icon
    if self.icon.blank?
      self.icon.attach(io: File.open(Rails.root.join('public/assets/boleto.png')), filename: 'boleto.png') if self.boleto?
      self.icon.attach(io: File.open(Rails.root.join('public/assets/credit_card.jpg')), filename: 'credit_card.jpg') if self.credit_card?
      self.icon.attach(io: File.open(Rails.root.join('public/assets/pix.jpeg')), filename: 'pix.jpeg') if self.pix?
    end
  end
end
