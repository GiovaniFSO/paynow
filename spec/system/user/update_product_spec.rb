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
    visit user_dashboard_index_path
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

  it 'successfully log', versioning: true do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))    
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)

    payment_method_pix = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method_pix.id, kind: pix)
    
    Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: 2, discount: 7.0, user_id: user.id)

    visit user_dashboard_index_path
    click_on 'Produtos'
    click_on 'Editar'
    fill_in 'Nome', with: 'Curso Laravel'
    fill_in 'Preço', with: 75.0
    select 'boleto - vermelhinho', from: 'Forma de pagamento'
    fill_in 'Desconto %', with: 5.0
    click_on 'Salvar'
    
    product = Product.last
    expect(product.paper_trail.previous_version.name).to eq 'Curso Ruby on Rails'
    expect(product.name).to eq 'Curso Laravel'
    expect(product.paper_trail.previous_version.value).to eq 60.0
    expect(product.value).to eq  75.0
    expect(product.paper_trail.previous_version.user_payment_method_id).to eq 2
    expect(product.user_payment_method_id).to eq 1
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
    visit user_dashboard_index_path
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