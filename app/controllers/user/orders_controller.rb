class User::OrdersController < ApplicationController

  def index
    @orders = Order.by_filter(params)
  end
      
  private
      
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