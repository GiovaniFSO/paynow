require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it { should validate_length_of(:account).is_equal_to(20)
                                            .with_message('não possui o tamanho esperado (20 caracteres)') }
  it { should have_many(:user_payment_methods) }
end
