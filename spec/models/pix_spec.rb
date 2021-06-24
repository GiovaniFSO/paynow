require 'rails_helper'

RSpec.describe Pix, type: :model do
  it { should validate_presence_of(:key).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:bank_code).with_message('não pode ficar em branco') }
  it { should validate_length_of(:key).is_equal_to(20)
                                            .with_message('não possui o tamanho esperado (20 caracteres)') }
  it { should validate_length_of(:bank_code).is_equal_to(3)
                                            .with_message('não possui o tamanho esperado (3 caracteres)') }
  it { should have_many(:user_payment_methods) }
end
