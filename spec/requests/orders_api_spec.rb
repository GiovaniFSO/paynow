require 'rails_helper'

describe 'Orders API' do
  context 'POST /api/v1/orders' do
    it 'should create a order to boleto' do 
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(response.body).to include('ParĂ¢metro InvĂ¡lido')
    end

    it 'invalid product token' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(response.body).to include('ParĂ¢metro InvĂ¡lido')
    end

    it 'invalid customer token' do     
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(response.body).to include('ParĂ¢metro InvĂ¡lido')
    end

    it 'invalid user token' do     
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(response.body).to include('ParĂ¢metro InvĂ¡lido')
    end

    it 'address can`t be blank to boleto' do 
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(parsed_body['address']).to include('nĂ£o pode ficar em branco')
    end    

    it 'credit card details can`t be blank' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      expect(parsed_body['number']).to include('nĂ£o pode ficar em branco')
      expect(parsed_body['name']).to include('nĂ£o pode ficar em branco')
      expect(parsed_body['safe_code']).to include('nĂ£o pode ficar em branco')
    end

    it 'should create a order with original and final price(discount) to boleto ' do 
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
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

  context 'GET /api/v1/orders' do
    it 'filter by created_at' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
      boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
      boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
      order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      order.order_details.new.info = boleto_detail
      order.save!
      
      old_order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id, created_at: DateTime.current.yesterday)
      old_order.order_details.new.info = boleto_detail
      old_order.save!

      get '/api/v1/orders', params: { 
        company: {
          token: company.token
        },
        created_at: order.created_at 
      }

      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(200)
      expect(parsed_body[0]['token']).to eq(order.token)
      expect(parsed_body[0]['status']).to eq('pendente')
      expect(parsed_body[0]['original_price']).to eq('60.0')
      expect(get_money parsed_body[0]['final_price']).to eq(get_money (product.value - product.discount*100/product.value))
      expect(parsed_body[0]['payment_method']['kind']).to eq('boleto')
      expect(parsed_body[0]['token_company']).to eq(company.token)
      expect(parsed_body[0]['token_product']).to eq(product.token)
      expect(parsed_body[0]['token_customer']).to eq(company.customers.first.token)
      expect(parsed_body.count).to eq(1)
    end

    it 'filter by payment_method' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
      other_payment_method = PaymentMethod.create(name: 'amarelhinho', fee: 3, max_fee: 12, kind: 3)  
      boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
      pix = Pix.create(key: '123123eqwd12reqw12eq', bank_code: '001')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
      other_user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: other_payment_method.id, kind: pix)
      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
      other_product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: other_user_payment_method.id, discount: 3.0, user_id: user.id)
      boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
      order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      order.order_details.new.info = boleto_detail
      order.save!
      other_order = Order.create(token_company: company.token,  token_product: other_product.token, token_customer: company.customers.last.token,
                   payment_method_id: other_user_payment_method.payment_method_id)
                   other_order.save!

      get '/api/v1/orders', params: { 
        company: {
          token: company.token
        },
        payment_method: order.payment_method_id 
      }
      
      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(200)
      expect(parsed_body[0]['token']).to eq(order.token)
      expect(parsed_body[0]['status']).to eq('pendente')
      expect(parsed_body[0]['original_price']).to eq('60.0')
      expect(get_money parsed_body[0]['final_price']).to eq(get_money (product.value - product.discount*100/product.value))
      expect(parsed_body[0]['payment_method']['kind']).to eq('boleto')
      expect(parsed_body[0]['token_company']).to eq(company.token)
      expect(parsed_body[0]['token_product']).to eq(product.token)
      expect(parsed_body[0]['token_customer']).to eq(company.customers.first.token)
      expect(parsed_body.count).to eq(1)
    end

    it 'get all orders' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
      boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
      boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
      order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      order.order_details.new.info = boleto_detail
      order.save!

      other_order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      other_order.order_details.new.info = boleto_detail
      other_order.save!

      get '/api/v1/orders', params: { 
        company: {
          token: company.token
        }
      }
      
      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(200)
      expect(parsed_body[0]['token']).to eq(order.token)
      expect(parsed_body[0]['status']).to eq('pendente')
      expect(parsed_body[0]['original_price']).to eq('60.0')
      expect(get_money parsed_body[0]['final_price']).to eq(get_money (product.value - product.discount*100/product.value))
      expect(parsed_body[0]['payment_method']['kind']).to eq('boleto')
      expect(parsed_body[0]['token_company']).to eq(company.token)
      expect(parsed_body[0]['token_product']).to eq(product.token)
      expect(parsed_body[0]['token_customer']).to eq(company.customers.first.token)
      expect(parsed_body.count).to eq(2)
    end

    it 'invalid token - blank' do
      company = Company.create!(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no MaracanĂ£')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      user = User.create!(email: 'giovani@codeplay.com.br', password: '123456')
      payment_method = PaymentMethod.create(name: 'vermelhinho', fee: 2.5, max_fee: 15, kind: 1)  
      boleto = Boleto.create(bank_code: '001', agency: '8764-0', account: '183725172893')
      user_payment_method = UserPaymentMethod.create!(user_id: user.id, payment_method_id: payment_method.id, kind: boleto)
      product = Product.create(name: 'Curso Ruby on Rails', value: 60.0, user_payment_method_id: user_payment_method.id, discount: 7.0, user_id: user.id)
      boleto_detail = BoletoDetail.create(address: 'rua perto do planato central, numero 515')
      order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      order.order_details.new.info = boleto_detail
      order.save!

      other_order = Order.create(token_company: company.token,  token_product: product.token, token_customer: company.customers.last.token,
                   payment_method_id: user_payment_method.payment_method_id)
      other_order.order_details.new.info = boleto_detail
      other_order.save!

      get '/api/v1/orders', params: { 
        company: {
          token: ''
        }
      }
      
      expect(response).to have_http_status(404)
      expect(response.body).to include('Token InvĂ¡lido')
    end
  end
end