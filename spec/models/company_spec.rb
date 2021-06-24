require 'rails_helper'

RSpec.describe Company, type: :model do
  it { should validate_presence_of(:cnpj).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:name).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:address).with_message('não pode ficar em branco') }
  it { should validate_presence_of(:email).with_message('não pode ficar em branco') }
  it { should validate_length_of(:cnpj).is_equal_to(14)
                                            .with_message('não possui o tamanho esperado (14 caracteres)') }
  it { should validate_uniqueness_of(:cnpj).with_message('já está em uso') }
  it { should validate_numericality_of(:cnpj) }
  it { should have_many(:users) }
  it { should have_many(:company_customers) }
  it { should have_many(:orders) }
  it { should have_many(:customers) }
end
