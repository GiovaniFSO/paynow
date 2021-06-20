require 'rails_helper'

describe 'Orders API' do
  context 'POST /api/v1/order' do
    it 'should create a customer with a new association' do 
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
      boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_user: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          boleto: {
            address: 'rua perto do planato central, numero 515'
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['token']).to eq(Order.last.token)
    end
  end
end