class Api::V1::OrdersController < Api::V1::ApiController
  
  def index
    company = Company.find_by!(token: params[:company][:token])
    orders = company.orders.from_date(params[:created_at]).from_payment_method(params[:payment_method])

    return render json: { message: 'Nenhum resultado encontrado' } if company.orders.blank?

    render json: orders.as_json(only: [:token, :status, :original_price, :final_price,
                                       :token_company, :token_product, :token_customer, :created_at],
                                 include: { 
                                            payment_method: { only: [:kind] } 
                                          })
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Token Inválido' }, status: 404
  end

  def create
    order = Order.new(order_params) 
    order.transaction do
      if order.save
        order.order_details.new.info = save_details
        render json: order.as_json(only: [:token, :final_price, :original_price, :status]), status: :created
      else
        render json: { message: 'Parâmetro Inválido' }, status: :precondition_failed
      end
    end
  end
    
  private
  
  def save_details    
    if params[:order].has_key?('boleto')
      BoletoDetail.create!(params_permit)  
    elsif params[:order].has_key?('credit_card')
      CreditCardDetail.create!(params_permit)
    end
  end

  def params_permit
    if params[:order].has_key?('boleto')
      params.require(:order).permit(boleto: [:address]).each{ |param| return param[1] }
    elsif params[:order].has_key?('credit_card')
      params.require(:order).permit(credit_card: [:number, :name, :safe_code]).each{ |param| return param[1] }
    end
  end

  def order_params
    params.require(:order).permit(:token_company, :token_product, :payment_method_id, :token_customer)
  end
end