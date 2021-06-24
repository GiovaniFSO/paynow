require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:cpf).with_message('não pode ficar em branco') }
  it { should validate_length_of(:cpf).is_equal_to(11)
                                            .with_message('não possui o tamanho esperado (11 caracteres)') }
  it { should validate_numericality_of(:cpf) }
  it { should have_many(:orders) }
  it { should have_many(:companies) }
  it { should have_many(:company_customers) }
end