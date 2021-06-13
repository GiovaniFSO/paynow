require 'rails_helper'

describe 'Admin view payment method' do 
  it 'must to be logged to view the payment methods' do 
    visit admin_payment_methods_path
    
    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_content('Para continuar, efetue login ou registre-se')
  end

  it 'successfully' do
    PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1)
    PaymentMethod.create(name: 'laranjinha', fee: 3.5, max_fee: 20, kind: 2)

    admin_login
    visit root_path
    click_on 'Meios de pagamentos'
    
    expect(page).to have_content('laranjinha')
    expect(page).to have_content('2,50%')
    expect(page).to have_content('R$ 15,00')
    expect(page).to have_content('boleto')
  end

  it 'and view details' do
    PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1, icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    PaymentMethod.create(name: 'laranjinha', fee: 3.5, max_fee: 20, kind: 3, icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
    

    admin_login
    visit root_path
    click_on 'Meios de pagamentos'
    all('.details').last.click

    expect(page).to have_content('laranjinha')
    expect(page).to have_content('3,50%')
    expect(page).to have_content('R$ 20,00')
    expect(page).to have_content('pix')
    expect(page).to have_css('img[src*="pix.jpeg"]')
  end

  it 'and no payment method available' do 
    admin_login
    visit root_path
    click_on 'Meios de pagamentos'

    expect(page).to have_content('Nenhum meio de pagamento cadastrado')
    expect(page).to_not have_link('+ detalhes')
  end
end