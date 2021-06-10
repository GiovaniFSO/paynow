require 'rails_helper'

describe 'Admin register payment method' do
  it 'must to be logged to view the payment methods' do 
    visit admin_payment_methods_path

    expect(current_path).to eq(new_admin_session_path)
  end

  it 'must to be logged create the payment methods' do 
    visit new_admin_payment_method_path

    expect(current_path).to eq(new_admin_session_path)
  end

  it 'successfully' do
    admin_login
    visit root_path
    
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    select 'pix', from: 'Forma de Pagamento'
    fill_in 'Nome', with: 'nubank'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18
    click_on 'Criar'

    expect(current_path).to eq(admin_payment_methods_path)
    expect(page).to have_content('nubank')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    #TODO attach
  end  

  it "and attributes can't be blank " do
    admin_login
    visit root_path
    click_on 'Meios de pagamentos'
    click_on 'Novo meio de pagamento'

    click_on 'Criar'

    expect(page).to have_content('não pode ficar em branco', count: 4)
  end
end