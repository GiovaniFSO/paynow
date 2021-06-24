require 'rails_helper'

describe 'Admin update orders' do 
  it 'approved' do 
    company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
    user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
    boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
    order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id)
    order.order_details.new.info = boleto_detail
    order.save!

    admin_login
    visit root_path
    click_on 'Pedidos'
    click_on 'Visualizar'
    click_on 'Aprovar'

    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('R$ 60,00')
    expect(page).to have_content('R$ 48,33')
    expect(page).to have_content(order.customer.name)
    expect(page).to have_content('Rejeitar')
    expect(page).to_not have_link('Aprovar')
  end

  #TODO adicionar selenium
  xit 'reject' do 
    company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
    user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
    boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
    order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id)
    order.order_details.new.info = boleto_detail
    order.save!

    admin_login
    visit root_path
    click_on 'Pedidos'
    click_on 'Visualizar'
    click_on 'Rejeitar'
    select 'Cobranca Recusada Por Dados Incorretos Para Cobranca', from: 'Motivo'

    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('R$ 60,00')
    expect(page).to have_content('R$ 48,33')
    expect(page).to_not have_content('Rejeitar')
    expect(page).to have_link('Aprovar')
    expect(order.status).to eq('pendente')
  end
end