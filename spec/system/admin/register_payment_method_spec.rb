require 'rails_helper'

describe 'Admin register payment method' do
  it 'must to be logged create the payment methods' do 
    visit new_admin_payment_method_path

    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_content('Para continuar, efetue login ou registre-se')
  end

  it 'successfully boleto with image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'boleto', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18
    attach_file('Icone do Meio de Pagamento', Rails.root.join('public', 'assets', 'boleto.png'))

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="boleto.png"]')
  end 
  
  it 'successfully boleto without image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'boleto', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="boleto.png"]')
  end  

  it 'successfully credit card with image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'credit_card', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18
    attach_file('Icone do Meio de Pagamento', Rails.root.join('public', 'assets', 'credit_card.jpg'))

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="credit_card.jpg"]')
  end 

  it 'successfully credit card without image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'credit_card', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="credit_card.jpg"]')
  end 

  it 'successfully credit card with image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'pix', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18
    attach_file('Icone do Meio de Pagamento', Rails.root.join('public', 'assets', 'pix.jpeg'))

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="pix.jpeg"]')
  end 

  it 'successfully credit card without image' do
    admin_login
    visit admin_root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'pix', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18

    click_on 'Salvar'

    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="pix.jpeg"]')
  end

  it "and attributes can't be blank " do
    admin_login
    visit admin_root_path
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    click_on 'Salvar'

    expect(page).to have_content('não pode ficar em branco', count: 4)
  end

  #TODO uniq  kind + name
end