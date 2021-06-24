require 'rails_helper'

RSpec.describe UserPaymentMethod, type: :model do
  it { should validate_presence_of(:kind_id).with_message('não pode ficar em branco') }
  it { should belong_to(:user) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:kind) }
end
