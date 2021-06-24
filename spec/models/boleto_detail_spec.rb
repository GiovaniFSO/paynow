require 'rails_helper'

RSpec.describe BoletoDetail, type: :model do
  it { should validate_presence_of(:address).with_message('não pode ficar em branco') }
end
