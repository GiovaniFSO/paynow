require 'rails_helper'

describe 'User view orders' do
  it 'by last 30 days' do
    user = user_login 
    company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
    boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
    order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id)
    order.order_details.new.info = boleto_detail
    order.save!
    other_order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id, created_at: 2.months.ago)
    other_order.order_details.new.info = boleto_detail
    other_order.save!

    
    visit user_dashboard_index_path
    click_on 'Pedidos'

    expect(page).to have_content('R$ 60,00')
    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('Giovani Fernandes')
    expect(page).to have_css('tbody > tr:nth-child(1)')
    expect(page).to_not have_css('tbody > tr:nth-child(2)')
  end  

  it 'by last 90 days' do
    user = user_login 
    company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
    boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
    order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id)
    order.order_details.new.info = boleto_detail
    order.save!
    other_order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id, created_at: 2.months.ago)
    other_order.order_details.new.info = boleto_detail
    other_order.save!
    other_order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                               payment_method_id: user_payment_method.payment_method_id, created_at: 4.months.ago)
    other_order.order_details.new.info = boleto_detail
    other_order.save!


    
    visit user_dashboard_index_path
    click_on 'Pedidos'
    click_on 'Últimos 90 Dias'

    expect(page).to have_content('R$ 60,00')
    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('Giovani Fernandes')
    expect(page).to have_css('tbody > tr:nth-child(1)')
    expect(page).to have_css('tbody > tr:nth-child(2)')
    expect(page).to_not have_css('tbody > tr:nth-child(3)')
  end

  it 'all orders' do
    user = user_login 
    company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
    payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
    boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
    user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
    product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
    boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
    order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id)
    order.order_details.new.info = boleto_detail
    order.save!
    second_order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                 payment_method_id: user_payment_method.payment_method_id, created_at: 2.months.ago)
    second_order.order_details.new.info = boleto_detail
    second_order.save!
    third_order = Order.create(token_company: company.token, token_product: product.token, token_customer: company.customers.last.token,
                               payment_method_id: user_payment_method.payment_method_id, created_at: 2.years.ago)
    third_order.order_details.new.info = boleto_detail
    third_order.save!


    
    visit user_dashboard_index_path
    click_on 'Pedidos'
    click_on 'Histórico Completo'

    expect(page).to have_content('R$ 60,00')
    expect(page).to have_content('Curso Ruby on Rails')
    expect(page).to have_content('7,00%')
    expect(page).to have_content('Giovani Fernandes')
    expect(page).to have_css('tbody > tr:nth-child(1)')
    expect(page).to have_css('tbody > tr:nth-child(2)')
    expect(page).to have_css('tbody > tr:nth-child(3)')
  end

  it 'empty orders' do
    user_login 
    visit user_dashboard_index_path
    click_on 'Pedidos'

    expect(page).to have_content('Nenhum pedido efetuado')
  end
end