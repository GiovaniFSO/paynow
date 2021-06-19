require 'rails_helper'

describe 'User update product' do
  it 'successfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))    
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)

    payment_method_pix = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method_pix.id, kind: pix)

    
    Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: 2, discount: 7.0)
    visit root_path
    click_on 'Produtos'
    click_on 'Cadastrar Produto'
    
    fill_in 'Nome', with: 'Curso de Laravel'
    fill_in 'Preço', with: 75.0
    select 'pix - roxinho', from: 'Forma de pagamento'
    fill_in 'Desconto %', with: 5.0
    click_on 'Salvar'

    expect(page).to have_content('Curso de Laravel')
    expect(page).to have_content('R$ 75,00')
    expect(page).to have_content('pix - roxinho')
    expect(page).to have_content('5,00%')
  end  

  it 'invalida params' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))    
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)

    payment_method_pix = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method_pix.id, kind: pix)

    
    Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: 2, discount: 7.0)
    visit root_path
    click_on 'Produtos'
    click_on 'Cadastrar Produto'
    
    fill_in 'Nome', with: ''
    fill_in 'Preço', with: ''
    select 'Selecione', from: 'Forma de pagamento'
    fill_in 'Desconto %', with: 5.0
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 3)
  end  
end