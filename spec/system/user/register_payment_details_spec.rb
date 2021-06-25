require 'rails_helper'

describe 'User register paymente details from your company' do 
  it 'sucessfully pix' do 
    PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    user_login
    visit user_dashboard_index_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'

    fill_in 'Chave PIX', with: '123fas31fj1hy2oi2211' 
    fill_in 'Codigo do banco', with: '001'
    click_on 'Salvar'    
    
    expect(page).to have_content('roxinho')
    expect(page).to have_content('123fas31fj1hy2oi2211') 
    expect(page).to have_content('001') 
  end

  it 'pix - key and bank code empty' do
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    user_login
    visit user_dashboard_index_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    click_on 'Salvar'    
    
    expect(page).to have_content('Chave Pix ou código de banco inválido')
    expect(page).to  have_selector(:link_or_button, 'Salvar')
    expect(current_path).to eq(user_payment_method_user_payment_methods_path(payment_method)) 
  end

  it 'sucessfully boleto' do 
    PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    user_login
    visit user_dashboard_index_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    
    fill_in 'Código do banco', with: '001' 
    fill_in 'Agência', with: '8764-0'
    fill_in 'Conta bancária', with: '183725172893'
    click_on 'Salvar'    
    
    expect(page).to have_content('vermelhinho')
    expect(page).to have_content('183725172893') 
    expect(page).to have_content('8764-0') 
    expect(page).to have_content('001') 
  end

  it 'boleto - bank_code, agency, account empty' do 
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    
    user_login
    visit user_dashboard_index_path
    
    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    click_on 'Salvar'

    expect(page).to have_content('Código de banco, agência, ou conta bancária inválido')
    expect(page).to  have_selector(:link_or_button, 'Salvar')
    expect(current_path).to eq(user_payment_method_user_payment_methods_path(payment_method)) 
  end

  it 'sucessfully credit_card' do 
    PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
    user_login
    visit user_dashboard_index_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    
    fill_in 'Numero do cartão', with: '12312312312312312312'
    click_on 'Salvar'    
    
    expect(page).to have_content('amarelinho')
    expect(page).to have_content('12312312312312312312') 
  end

  it 'credit_card - account empty' do 
    payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
    user_login
    visit user_dashboard_index_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    click_on 'Salvar'    
    
    expect(page).to have_content('Numero do cartão inválido')
    expect(page).to  have_selector(:link_or_button, 'Salvar')
    expect(current_path).to eq(user_payment_method_user_payment_methods_path(payment_method))  
  end
end