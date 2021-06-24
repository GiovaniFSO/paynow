require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:fee).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:max_fee).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:kind).with_message('não pode ficar em branco') }
  it { should validate_numericality_of(:fee) }
  it { should validate_numericality_of(:max_fee) }
  it { should have_one_attached(:icon) }
end