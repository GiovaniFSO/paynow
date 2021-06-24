require 'rails_helper'

RSpec.describe CreditCardDetail, type: :model do
  it { should have_many(:order_details) }
  it { should validate_presence_of(:number).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:safe_code).with_message('não pode ficar em branco') }
end