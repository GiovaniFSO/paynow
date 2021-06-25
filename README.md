
# Paynow - TreinaDev Turma 06

O projeto final desta etapa visa replicar em uma aplicação real(MVP) os conhecimentos adquiridos no treinamento.

## Sobre

Uma ferramenta de pagamentos, possuindo os perfis de USUARIO(donos de negócios que querem vender seus produtos) 
e ADMINISTRADORES da plataforma, capaz de configurar os meios de pagamentos e 
registrar as cobranças referentes a cada venda de produtos cadastrados pelos USUARIOS. 

## Requisitos Necessários/Recomendados

 - Ruby 3.0.1
 - Rails 6.1.3
 - ### Dependências do projeto
    - Autenticação
        - [Devise](https://github.com/heartcombo/devise)
    - Testes    
        - [Rspec](https://github.com/rspec/rspec)
        - [Capybara](https://github.com/teamcapybara/capybara)
    - Auditoria    
        - [Papertrail](https://github.com/paper-trail-gem/paper_trail)

  
## Funcionalidades

Administradores:

- Gerenciam meios de pagamentos
- Gerenciam empresas cadastradas na plataforma

Usuarios:
- Cadastrar empresa na plataforma  
- Gerenciar meios de pagamentos disponivéis para a empresa
- Gerenciar produtos
- Emitir cobrança via API

Clientes Finais:
- Emitir recibo

Obs.: 
- emails públicos como gmail, hotmail, não são válidos
- necessita do dominio paynow.com.br(Administradores) no email



## Executar o projeto

No terminal, clone o projeto atraves do comando:

```bash 
  git clone git@github.com:GiovaniFSO/paynow.git
```
Instalar dependências 

```bash 
  cd paynow
  bin/setup
```   

Popular o banco de dados

```bash 
  rails db:seed
```   









### Criar um cliente
URL

```http
  POST /api/v1/customers
```
JSON
```
 {
	"customer": 
	 { 
		 "name": "Giovani Fernandes", 
		 "cpf": "12345678987" 
	 },
	"token": "k1i2hdyaw2u1i231jduw1"  
 }
```

#### Success Response:

Código: 200
```
{ json: "Cliente já cadastrado" }
```

Código: 201
```
{ name : "Giovani Fernandes" }
```


#### Error Response:



Código: 422 Unprocessable Entity
```
{
    "name": [
        "não pode ficar em branco"
    ],
    "cpf": [
        "não pode ficar em branco",
        "não possui o tamanho esperado (11 caracteres)",
        "não é um número"
    ]
}

```

Código: 412 Precondition Failed
```
{
    "message": "Token Inválido"
}
```
OU 
```
{
    "errors": "Parâmetros inválidos"
}
```
&nbsp;
&nbsp;


### Criar um pedido
URL

```http
  POST /api/v1/orders
```
JSON - Boleto
```
{ 
    "order": { 
        "token_company": "0b224679b57e4c06e01f",
        "token_product": "47ee8fba34b0e0543504",
        "token_customer": "596f87698fb9f96491f2",
        "payment_method_id": 1,
        "boleto": {
          "address": "Av. Paulista, 493"
        }
    }
}
```
JSON - Cartão de credito
```
{ 
    "order": { 
        "token_company": "0b224679b57e4c06e01f",
        "token_product": "47ee8fba34b0e0543504",
        "token_customer": "596f87698fb9f96491f2",
        "payment_method_id": 4,
        "credit_card": {
            "number": "12313213321412456432",
            "name": "Giovani Fernandes",
            "safe_code": 382
          }
    }
}
```
JSON - Pix
```
{ 
    "order": { 
        "token_company": "0b224679b57e4c06e01f",
        "token_product": "47ee8fba34b0e0543504",
        "token_customer": "596f87698fb9f96491f2",
        "payment_method_id": ""
    }
}
```
#### Success Response:

Código: 201
```
{
    "token": "8c50d9c71ec0c2dc3a8d",
    "original_price": "12.53",
    "final_price": "4.549154030327214684756584197",
    "status": "pendente"
}
```


#### Error Response:



Código: 422 Unprocessable Entity
```
{
    "address": [
        "não pode ficar em branco"
    ]
}

```

Código: 412 Precondition Failed
```
{
    "errors": "Parâmetros inválidos"
}
```
&nbsp;
&nbsp;

### Buscar pedidos efetuados
URL

```http
  GET /api/v1/orders
```
JSON
```
{ 
    "company": {
        "token": "5723a02b451128ffd2b0"
    },
    "created_at": "2021-06-24 18:07:49" 
}
```

#### Success Response:

Código: 200 OK
```
[
    {
        "token_company": "5723a02b451128ffd2b0",
        "token_product": "283626519d3ec8d61945",
        "token": "57bd223eef3a7e32733e",
        "created_at": "2021-04-24T18:03:38.752-03:00",
        "token_customer": "ecd905ed491b4f85f713",
        "original_price": "60.0",
        "final_price": "48.33333333333334",
        "status": "pendente",
        "payment_method": {
            "kind": "boleto"
        }
    },
    {
        "token_company": "5723a02b451128ffd2b0",
        "token_product": "283626519d3ec8d61945",
        "token": "bc5e41a013d69077206c",
        "created_at": "2021-06-24T18:03:38.805-03:00",
        "token_customer": "f381b182f7e67eb6f823",
        "original_price": "60.0",
        "final_price": "48.33333333333334",
        "status": "pendente",
        "payment_method": {
            "kind": "boleto"
        }
    }
]
```

#### Error Response:

Código: 404 Not Fount
```
{
    "message": "Token Inválido"
}

```

&nbsp;
&nbsp;



