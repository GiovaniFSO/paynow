Admin.create!(email: "admin@paynow.com.br", password: 123456)
PaymentMethod.create!(id: 1, kind: "boleto", name: "Itau", fee: 0.37e1, max_fee: 0.15e2, active: true)
PaymentMethod.create!(id: 2, kind: "boleto", name: "Banco do Brasil", fee: 0.27e1, max_fee: 0.12e2, active: true)
PaymentMethod.create!(id: 3, kind: "credit_card", name: "Caixa", fee: 0.19e1, max_fee: 0.9e1, active: true)
PaymentMethod.create!(id: 4, kind: "credit_card", name: "Santander", fee: 0.42e1, max_fee: 0.14e2, active: true)
PaymentMethod.create!(id: 5, kind: "pix", name: "Nubank", fee: 0.12e1, max_fee: 0.5e1, active: true)
PaymentMethod.create!(id: 6, kind: "pix", name: "Inter", fee: 0.9e0, max_fee: 0.7e1, active: true)
Company.create!(id: 1, cnpj: "12314123141231",name: "CodePlay",address: "Av. Capitão Ene Garcez",email: "company@codeplay.com",token: "0b224679b57e4c06e01f",block: "desbloqueado")
Customer.create(id: 1, cpf: "11111113111", name: "Giovani Fernandes", token: "596f87698fb9f96491f2")
User.create(id: 1, email: "usuario@codeplay.com", password: "123456", company_id: 1, adm: "administrador")
User.create(id: 2, email: "employee@codeplay.com", password: "123456", company_id: 1, adm: "usuario")
Boleto.create(id: 1, bank_code: "001", agency: "5780-0", account: "1234-2")
Boleto.create(id: 2, bank_code: "321", agency: "4321-2", account: "2331-2")
CreditCard.create(id: 1, account: "12314123123123123132")
CreditCard.create(id: 2, account: "54312345678987656765")
Pix.create( id: 1, key: "a31dsawe3rw23rghnjy6", bank_code: "120")
Pix.create( id: 2, key: "87uyikjh567f5hfr56yr", bank_code: "333")
UserPaymentMethod.create!(id: 1, user_id: 1, payment_method_id: 2, kind_type: "Boleto", kind_id: 1)
UserPaymentMethod.create!(id: 2, user_id: 1, payment_method_id: 1, kind_type: "Boleto", kind_id: 2)
UserPaymentMethod.create!(id: 3, user_id: 1, payment_method_id: 3, kind_type: "CreditCard", kind_id: 1)
UserPaymentMethod.create!(id: 4, user_id: 1, payment_method_id: 4, kind_type: "CreditCard", kind_id: 2)
UserPaymentMethod.create!(id: 5, user_id: 1, payment_method_id: 5, kind_type: "Pix", kind_id: 1)
UserPaymentMethod.create!(id: 6, user_id: 1, payment_method_id: 6, kind_type: "Pix", kind_id: 2)

Product.create!(id: 1, user_id: 1, name: "curso ruby", value: 0.5554e2, discount: 0.5e1, user_payment_method_id: 2, token: "9e5cd6df0fad7450a3a6")
Product.create!(id: 2, user_id: 1, name: "curso laravel", value: 0.2125e2, discount: 0.1e1, user_payment_method_id: 5, token: "47ee8fba34b0e0543504")
Product.create!(id: 3, user_id: 1, name: "Curso de React", value: 0.10321e3, discount: 0.0, user_payment_method_id: 3, token: "331620be85c28e4cfe10")
boleto_detail = BoletoDetail.create(id: 1, address: "Av. Paulista, 493")

order = Order.create(id: 1, token_company: "0b224679b57e4c06e01f", token_product: "47ee8fba34b0e0543504", payment_method_id: 1, 
                     token: "8c50d9c71ec0c2dc3a8d", token_customer: "596f87698fb9f96491f2", original_price: 0.1253e2, 
                     final_price: 0.4549154030327215e1, status: "pendente", created_at: 2.months.ago)
order.order_details.new.info = boleto_detail
order.save!

credit_card = CreditCardDetail.create!(id: 1, number: "12313213321412456432", name: "Giovani Fernandes", safe_code: "382")
order = Order.create(id: 2, token_company: "0b224679b57e4c06e01f", token_product: "9e5cd6df0fad7450a3a6", payment_method_id: 4, token: "f76655e8f27c37396bcd",
             token_customer: "596f87698fb9f96491f2", original_price: 0.1253e2, final_price: 0.4549154030327215e1, status: "pendente", created_at: DateTime.current.last_year)
order.order_details.new.info = credit_card             
order.save!

Order.create!(id: 3, token_company: "0b224679b57e4c06e01f", token_product: "331620be85c28e4cfe10", payment_method_id: 6, token: "a22e47a86b7eb6af1e97",
              token_customer: "596f87698fb9f96491f2", original_price: 0.1253e2, final_price: 0.4549154030327215e1, status: "pendente")