class Api::V1::CustomersController < Api::V1::ApiController

  def create
    customer_params
    company = Company.find_by!(token: params[:token])
    customer = Customer.find_by(cpf: params[:customer][:cpf])
    
    if company.customers.include?(customer)
      return render json: 'Cliente já cadastrado', status: :ok
    elsif customer
      company.company_customers.create!(customer: customer)
    else
      customer = company.customers.create!(customer_params)  
    end
    render json: customer.as_json(only: [:name]), status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token Inválido' }, status: :precondition_failed
  end  

  private 

  def customer_params
    params.require(:customer).permit(:cpf, :name)
  end
end