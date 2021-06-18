require 'rails_helper'

describe 'User edit details from payment methods' do
  it 'pix - sucessfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Chave PIX', with: '98753dgeyw63uwiq72iq' 
    fill_in 'Codigo do banco', with: '003'
    click_on 'Salvar'    
    
    expect(page).to have_content('roxinho')
    expect(page).to have_content('98753dgeyw63uwiq72iq') 
    expect(page).to have_content('003') 
  end 

  it 'pix - key and bank_code invalid' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Chave PIX', with: '98753geyw63uwiq72iq' 
    fill_in 'Codigo do banco', with: '0033'
    click_on 'Salvar'    
    
    expect(page).to have_content('Chave Pix ou código de banco inválido')
    expect(page).to have_field('Chave PIX', with: '98753geyw63uwiq72iq')
    expect(page).to have_field('Codigo do banco', with: '0033')
  end 

  it 'boleto - sucessfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Código do banco', with: '002' 
    fill_in 'Agência', with: '9764-0'
    fill_in 'Conta bancária', with: '203725172893'
    click_on 'Salvar'    
    
    expect(page).to have_content('vermelhinho')
    expect(page).to have_content('203725172893') 
    expect(page).to have_content('9764-0') 
    expect(page).to have_content('002') 
  end 
  
  it 'boleto - invalid bank_code' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Código do banco', with: '12302' 
    fill_in 'Agência', with: '9764-0'
    fill_in 'Conta bancária', with: '20372512322893'
    click_on 'Salvar'    
    
    expect(page).to have_content('Código de banco, agência, ou conta bancária inválido') 
    expect(page).to have_field('Código do banco', with: '12302') 
    expect(page).to have_field('Agência', with: '9764-0') 
    expect(page).to have_field('Conta bancária', with: '20372512322893') 
  end 

  it 'credit_card - sucessfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
    credit_card = CreditCard.create(account: '12312312312312312312')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Numero do cartão', with: '32132132132132132132' 
    click_on 'Salvar'    
    
    expect(page).to have_content('amarelinho')
    expect(page).to have_content('32132132132132132132') 
  end 

  it 'credit_card - number account invalid' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
    credit_card = CreditCard.create(account: '12312312312312312312')
    UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)
    
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Numero do cartão', with: '321321321321321321' 
    click_on 'Salvar'    
    
    expect(page).to have_content('Numero do cartão inválido')
    expect(page).to have_field('Numero do cartão', with: '321321321321321321') 
  end 
end