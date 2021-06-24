require 'rails_helper'

RSpec.describe Boleto, type: :model do
  it { should validate_presence_of(:bank_code).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:agency).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:account).with_message('não pode ficar em branco') }
  it { should validate_length_of(:bank_code).is_equal_to(3)
                                            .with_message('não possui o tamanho esperado (3 caracteres)') }
end
