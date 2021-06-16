require 'rails_helper'

describe 'User register company' do
  it 'sucessfully' do
    User.create!(email: 'fulano@codeplay.com.br', password: '123456', password_confirmation: '123456')
    visit root_path
    click_on 'Login'

    fill_in 'Email', with: 'fulano@codeplay.com.br'
    fill_in 'Senha', with: '123456'
    click_on 'Entrar'
    
    fill_in 'Cnpj', with: '12345678654432'
    fill_in 'Nome', with: 'Codeplay'
    fill_in 'Email', with: 'company@codeplay.com.br'
    fill_in 'Endereço', with: 'rua blablabla, bairro lá longe'
    click_on 'Salvar'

    expect(page).to have_content('Dashboard usuarioooo')
    expect(page).to have_content('Menu')
  end  
  
  it 'attributes null' do
    User.create!(email: 'fulano@codeplay.com.br', password: '123456', password_confirmation: '123456')
    visit root_path
    click_on 'Login'

    fill_in 'Email', with: 'fulano@codeplay.com.br'
    fill_in 'Senha', with: '123456'
    click_on 'Entrar'
    
    
    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 4)
  end
end