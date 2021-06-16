require 'rails_helper'

describe 'User account Management' do 
  context 'registration' do 
    it 'with email and password' do  
      visit root_path
      click_on 'Login'
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Login efetuado com sucesso.'
      expect(page).to have_link 'Sair'
      expect(current_path).to eq new_user_company_path
    end 
    it 'with email, password and company' do  
      company = Company.create!(cnpj: '12345678912345', name: 'Codeplay', address: 'rua chegando na esquinda',
                      email: 'empresa@codeplay.com.br', block: 1, token: SecureRandom.hex(10))
      User.create!(email: 'fulano@codeplay.com.br', password: '123456', company_id: company.id)

      visit root_path
      click_on 'Login'
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Login efetuado com sucesso.'
      expect(page).to have_link 'Sair'
      expect(current_path).to eq root_path
    end 

    it 'with email not valid' do 
      visit root_path
      click_on 'Login'
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@gmail.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'
      
      expect(page).to have_content 'Email não é válido'
    end
    
    it 'with passord not match confirmation' do
      visit root_path
      click_on 'Login'
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123465'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Confirmação de Senha não é igual a Senha'
      expect(current_path).to eq(user_registration_path)
    end

    it 'with email not unique' do
      User.create!(email: 'giovani@codeplay.com.br', password: '123456', password_confirmation: '123456')  
      visit root_path
      click_on 'Login'
      click_on 'Registre-se'

      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirmação de Senha', with: '123456'
      click_on 'Criar Usuário(a)'

      expect(page).to have_content 'Email já está em uso'
      expect(current_path).to eq(user_registration_path)
    end
  end

  context 'sign in' do
    it 'with valid email and password registered' do
      User.create!(email: 'giovani@codeplay.com.br', password: '123456', password_confirmation: '123456')  
      visit root_path
      click_on 'Login'
      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
      
      expect(page).to have_content 'Login efetuado com sucesso!'
      expect(page).to have_content 'giovani@codeplay.com.br'
      expect(page).to have_link 'Sair'
      expect(current_path).to eq new_user_company_path
    end

    it 'with valid email but not registered' do
      visit root_path
      click_on 'Login'
      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
      
      expect(page).to_not have_link 'Sair'
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_user_session_path)
    end

    it 'without valid email' do
      visit root_path
      click_on 'Login'
      fill_in 'Email', with: 'giovani'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
  
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_user_session_path)
    end
  
    it 'without valid password' do 
      visit root_path
      click_on 'Login'
      fill_in 'Email', with: 'giovani@codeplay.com.br'
      fill_in 'Senha', with: '12345'
      click_on 'Entrar'
  
      expect(page).to have_content('Email ou senha inválida')
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context 'logout' do
    it 'successfully' do
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456', password_confirmation: '123456')  
      
      login_as user, scope: :user
      visit root_path
      click_on 'Sair'

      expect(page).to_not have_text('giovani@codeplay.com.br')
      expect(current_path).to eq(root_path)
      #expect(page).to have_selector(:link_or_button, 'Entrar')
      expect(page).to_not have_link('Sair')
    end
  end
end