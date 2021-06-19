require 'rails_helper'

describe 'User register product' do 
  it 'successfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    visit root_path
    click_on 'Produtos'
    click_on 'Cadastrar Produto'
    
    fill_in 'Nome', with: 'Curso Ruby on Rails'
    fill_in 'Preço', with: 75.0
    select 'boleto - vermelhinho', from: 'Forma de pagamento'
    fill_in 'Desconto %', with: 5.0
    click_on 'Salvar'

    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('R$ 75,00')
    expect(page).to have_content('boleto - vermelhinho')
    expect(page).to have_content('5,00%')
  end

  it 'invalid params' do     
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    visit root_path
    click_on 'Produtos'
    click_on 'Cadastrar Produto'
    
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 4)
    expect(page).to have_content('User payment method é obrigatório(a)')
  end

end