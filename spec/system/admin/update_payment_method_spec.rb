require 'rails_helper'

describe 'Admin update payment_method' do
  it 'sucessfully' do 
    PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1)

    admin_login
    visit admin_root_path
    click_on 'Meios de pagamentos'
    click_on 'Editar'
    fill_in 'Nome', with: 'vermelhinho'
    select 'pix', from: 'Forma de Pagamento'
    fill_in 'Taxa por Cobrança em (%)', with: 7
    fill_in 'Taxa Máxima em (R$)', with: 18
    attach_file('Icone do Meio de Pagamento', Rails.root.join('public', 'assets', 'pix.jpeg'))
    click_on 'Salvar'

    expect(page).to have_content('vermelhinho')
    expect(page).to have_content('pix')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('R$ 18,00')
    expect(page).to have_css('img[src*="pix.jpeg"]')
  end  

  it 'must be logged to update payment method' do
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    visit edit_admin_payment_method_path(payment_method)                                      
    
    expect(current_path).to eq(new_admin_session_path)
  end
end