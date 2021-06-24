require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:value).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:user_payment_method_id).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:discount).with_message('não pode ficar em branco') }
  it { should belong_to(:user_payment_method) }
  it { should belong_to(:user) }
  it { should have_many(:orders) }
end
