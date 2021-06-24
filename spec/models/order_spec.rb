require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many(:payments) }
  it { should have_many(:order_details) }
  it { should belong_to(:payment_method) }
  it { should belong_to(:company) }
  it { should belong_to(:product) }
  it { should belong_to(:customer) }
end