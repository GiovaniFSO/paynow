require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  it { should belong_to(:info) }
  it { should belong_to(:order) }
end