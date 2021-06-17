require 'rails_helper'

describe 'User register paymente details from your company' do 
  it 'sucessfully pix' do 
    PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    user_login
    visit root_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'

    fill_in 'Chave PIX', with: '12384ysoiqh271jdowiu1yd1' 
    fill_in 'Codigo do banco', with: '001'
    click_on 'Salvar'    
    
    expect(page).to have_content('roxinho')
    expect(page).to have_content('12384ysoiqh271jdowiu1yd1') 
    expect(page).to have_content('001') 
  end

  it 'sucessfully boleto' do 
    PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    user_login
    visit root_path

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

  it 'sucessfully credit_card' do 
    PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
    user_login
    visit root_path

    click_on 'Meios de pagamentos'
    click_on 'Configurar'
    save_page
    fill_in 'Numero do cartão', with: '18373215172893'
    click_on 'Salvar'    
    
    expect(page).to have_content('amarelinho')
    expect(page).to have_content('18373215172893') 
  end
end