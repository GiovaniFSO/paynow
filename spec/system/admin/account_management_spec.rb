require 'rails_helper'

describe 'Account Management' do 
  context 'registration' do 
    it 'with email and password' do  
      visit root_path
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Login efetuado com sucesso.'
      expect(page).to have_link 'Sair'
      expect(current_path).to eq root_path
    end 

    it 'with email not valid' do 
      visit root_path
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@gmail.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'
      
      expect(page).to have_content 'Email não é válido'
    end
    
    it 'with passord not match confirmation' do
      visit root_path
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123465'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Confirmação de Senha não é igual a Senha'
      expect(current_path).to eq(admin_registration_path)
    end

    it 'with email not unique' do
      Admin.create!(email: 'giovani@paynow.com.br', password: '123456', password_confirmation: '123456')  
      visit root_path
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Email já está em uso'
      expect(current_path).to eq(admin_registration_path)
    end
  end

  context 'sign in' do
    it 'with valid email and password registered' do
      Admin.create!(email: 'giovani@paynow.com.br', password: '123456', password_confirmation: '123456')  
      visit root_path
      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
      
      expect(page).to have_content 'Login efetuado com sucesso!'
      expect(page).to have_content 'giovani@paynow.com.br'
      expect(page).to have_link 'Sair'
      expect(current_path).to eq root_path
    end

    it 'with valid email but not registered' do
      visit root_path
      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
      
      expect(page).to_not have_link 'Sair'
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'without valid email' do
      visit root_path
      fill_in 'Email', with: 'giovani'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
  
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_admin_session_path)
    end
  
    it 'without valid password' do 
      visit root_path
      fill_in 'Email', with: 'giovani@paynow.com.br'
      fill_in 'Senha', with: '12345'
      click_on 'Entrar'
  
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_admin_session_path)
    end
  end

  context 'logout' do
    it 'successfully' do
      admin = Admin.create!(email: 'giovani@paynow.com.br', password: '123456', password_confirmation: '123456')  
      visit root_path
      
      login_as admin, scope: :admin
      visit root_path
      click_on 'Sair'

      expect(page).to_not have_text('giovani@paynow.com.br')
      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_selector(:link_or_button, 'Entrar')
      expect(page).to_not have_link('Sair')
    end
  end
end