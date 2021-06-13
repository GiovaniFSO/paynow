require 'rails_helper'

describe 'Admin destroy payment method' do
  it 'successfully from show' do 
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    admin_login
    visit admin_payment_method_path(payment_method)
    expect { click_on 'Deletar' }.to change { PaymentMethod.count }.by(-1)

    expect(page).to have_text('Meio de pagamento deletado com sucesso')
    expect(current_path).to eq(admin_payment_methods_path)                         
  end 
  
  it 'successfully from index' do 
    payment_method = PaymentMethod.create(name: 'roxinho', fee: 2.5, max_fee: 15, kind: 1, 
                                          icon: fixture_file_upload(Rails.root.join('public', 'assets', 'boleto.png')))
    admin_login
    visit admin_payment_methods_path
    expect { click_on 'Deletar' }.to change { PaymentMethod.count }.by(-1)

    expect(page).to have_text('Meio de pagamento deletado com sucesso')
    expect(current_path).to eq(admin_payment_methods_path)                         
  end 
end