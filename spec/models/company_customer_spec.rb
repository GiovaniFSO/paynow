require 'rails_helper'

RSpec.describe CompanyCustomer, type: :model do
  it { should belong_to(:customer) }
  it { should belong_to(:company) }
end
