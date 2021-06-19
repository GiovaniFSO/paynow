require 'rails_helper'

describe 'User view product' do 
  it 'successfully' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    Product.create!(name: 'Curso Ruby', value: 55.04, user_payment_method_id: user_payment.id, discount: 3.5, user_id: user.id)
    Product.create!(name: 'Curso Laravel', value: 35, user_payment_method_id: user_payment.id, discount: 2.7, user_id: user.id)
    visit root_path
    click_on 'Produtos'

    expect(page).to have_content('Curso Ruby')
    expect(page).to have_content('Curso Laravel')
    expect(page).to have_content('R$ 55,04')
    expect(page).to have_content('R$ 35,00')
    expect(page).to have_content('3,50%')
    expect(page).to have_content('2,70%')
  end

  it 'without product registered' do 
    user = user_login
    visit root_path
    click_on 'Produtos'

    expect(page).to have_content('Nenhum produto cadastrado')
  end

  it 'successfully with details' do
    user = user_login
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    Product.create!(name: 'Curso Ruby', value: 55.04, user_payment_method_id: user_payment.id, discount: 3.5, user_id: user.id)
    visit root_path
    click_on 'Produtos'
    click_on 'Visualizar'

    expect(page).to have_content('Curso Ruby')
    expect(page).to have_content('R$ 55,04')
    expect(page).to have_content('boleto - vermelhinho')
    expect(page).to have_content('3,50%')
  end
end