require 'rails_helper'

describe 'Orders API' do
  context 'POST /api/v1/orders' do
    it 'should create a order to boleto' do 
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
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          boleto: {
            address: 'rua perto do planato central, numero 515'
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['token']).to eq(Order.last.token)
      expect(parsed_body['token']).to_not eq(nil)
      expect(parsed_body['status']).to eq('pendente')
    end

    it 'should create a order to credit card' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
      credit_card = CreditCard.create(account: '12312312312312312312')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          credit_card: {
            number: '12313213',
            name: 'Giovani Fernandes',
            safe_code: 382
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['token']).to eq(Order.last.token)
      expect(parsed_body['token']).to_not eq(nil)
      expect(parsed_body['status']).to eq('pendente')
    end

    it 'should create a order to pix' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')

      payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
      pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['token']).to eq(Order.last.token)
      expect(parsed_body['token']).to_not eq(nil)
      expect(parsed_body['status']).to eq('pendente')
    end

    it 'invalid company token' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')

      payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
      pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: '',
          token_product: product.token,
          token_user: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
        },
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetro Inválido')
    end

    it 'invalid product token' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')

      payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
      pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: '',
          token_user: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
        },
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetro Inválido')
    end

    it 'invalid customer token' do     
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')

      payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
      pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_user: '',
          payment_method_id: user_payment_method.payment_method_id,
        },
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetro Inválido')
    end

    it 'invalid user token' do     
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')

      payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 3, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'pix.jpeg')))
      pix = Pix.create(key: '123fas31fj1hy2oi2211', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: pix)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_user: company.customers.last.token,
          payment_method_id: '',
        },
      }

      expect(response).to have_http_status(412)
      expect(response.body).to include('Parâmetro Inválido')
    end

    it 'address can`t be blank to boleto' do 
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
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          boleto: {
            address: ''
          }
        },
      }

      expect(response).to have_http_status(422)
      expect(parsed_body['address']).to include('não pode ficar em branco')
    end    

    it 'credit card details can`t be blank' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
      credit_card = CreditCard.create(account: '12312312312312312312')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          credit_card: {
            number: '',
            name: '',
            safe_code: ''
          }
        },
      }

      expect(response).to have_http_status(422)
      expect(parsed_body['number']).to include('não pode ficar em branco')
      expect(parsed_body['name']).to include('não pode ficar em branco')
      expect(parsed_body['safe_code']).to include('não pode ficar em branco')
    end

    it 'should create a order with original and final price(discount) to boleto ' do 
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
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          boleto: {
            address: 'rua perto do planato central, numero 515'
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['final_price']).to eq((product.value - product.discount*100/product.value).as_json)
      expect(parsed_body['original_price']).to eq(product.value.as_json)
      expect(parsed_body['final_price']).to_not eq(product.value.as_json)
    end  
    
    it 'should create a order with original and final price(discount) to credit card' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
      credit_card = CreditCard.create(account: '12312312312312312312')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          credit_card: {
            number: '12313213',
            name: 'Giovani Fernandes',
            safe_code: 382
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['final_price']).to eq((product.value - product.discount*100/product.value).as_json)
      expect(parsed_body['original_price']).to eq(product.value.as_json)
      expect(parsed_body['final_price']).to_not eq(product.value.as_json)
    end

    it 'should create a order with original and final price(discount) to pix' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'amarelinho', fee: 2.5, max_fee: 15, kind: 2, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'credit_card.jpg')))
      credit_card = CreditCard.create(account: '12312312312312312312')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: credit_card)

      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)

      post '/api/v1/orders', params: { 
        order: { 
          token_company: company.token,
          token_product: product.token,
          token_customer: company.customers.last.token,
          payment_method_id: user_payment_method.payment_method_id,
          credit_card: {
            number: '12313213',
            name: 'Giovani Fernandes',
            safe_code: 382
          }
        },
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['final_price']).to eq((product.value - product.discount*100/product.value).as_json)
      expect(parsed_body['original_price']).to eq(product.value.as_json)
      expect(parsed_body['final_price']).to_not eq(product.value.as_json)
    end
  end
end