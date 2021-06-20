require 'rails_helper'

describe 'Customers API' do
  context 'POST /api/v1/customers' do
    it 'should create a customer with a new association' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')

      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Fernandes',
          cpf: '11111111111'
        },
        token: company.token
      }

      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('Giovani Fernandes')
      expect(Customer.last.companies).to include(company)
      expect(CompanyCustomer.last.company_id).to eq(company.id)
      expect(CompanyCustomer.last.customer_id).to eq(Customer.last.id)
    end

    it 'should NOT create twice a new association or a new customer' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
  
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Oliveira',
          cpf: '11111111111'
        },
        token: company.token
      }
  
      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(200)
      expect(response.body).to eq('Cliente já cadastrado')
    end

    it 'previous customer registered should create a new association, but NOT create a customer' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
      company.customers.create(name: 'Giovani Fernandes', cpf: '11111111111')
      new_company = Company.create(cnpj: '98765431234123', name: 'Udemy', email: 'company@udemy.com.br', address: 'rua chegando no Pacaembu')
    
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Oliveira',
          cpf: '11111111111'
        },
        token: new_company.token
      }
    
      expect(response.content_type).to include('application/json')
      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('Giovani Fernandes')
      expect(Customer.last.companies).to include(new_company)
      expect(CompanyCustomer.last.company_id).to eq(new_company.id)
      expect(CompanyCustomer.last.customer_id).to eq(Customer.last.id)
      expect(Customer.last).to eq(new_company.customers.last)
      expect(Customer.last.token).to eq(new_company.customers.last.token)
    end

    it 'invalid token without Company' do 
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Fernandes',
          cpf: '11111111111'
        },
        token: 'dsadfsafsadfa12dsawq'
      }
  
      expect(response.body).to include('Token Inválido')
      expect(response).to have_http_status(412)
    end

    it 'invalid token with Company' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
    
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Fernandes',
          cpf: '11111111111'
        },
        token: 'dsadfsafsadfa12dsawq'
      }
    
      expect(response.body).to include('Token Inválido')
      expect(response).to have_http_status(412)
    end

    it 'should not create a course with invalid parameters' do
      post '/api/v1/customers'
  
      expect(response).to have_http_status(412)
      expect(response.content_type).to include('application/json')
      expect(response.body).to include('Parâmetros inválidos')
    end

    it 'invalid type cpf' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
        
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Fernandes',
          cpf: 'AA111111111'
        },
        token: company.token
      }

      expect(parsed_body['cpf']).to include('não é um número')
      expect(response).to have_http_status(422)
    end

    it 'invalid length cpf(11 characters)' do 
      company = Company.create(cnpj: '12345678654321', name: 'Codeplay', email: 'company@codeplay.com.br', address: 'rua chegando no Maracanã')
          
      post '/api/v1/customers', params: { 
        customer: { 
          name: 'Giovani Fernandes',
          cpf: '1111111111'
        },
        token: company.token
      }
  
      expect(parsed_body['cpf']).to include('não possui o tamanho esperado (11 caracteres)')
      expect(response).to have_http_status(422)
    end
  end
end