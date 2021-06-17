class User::PaymentMethodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment_method, only: %i[show]
  
  def index
    @payment_methods = PaymentMethod.all
  end  
    
  def show
    @user_payment_method = UserPaymentMethod.find_by(user_id: current_user.id, payment_method_id: @payment_method.id)
  end
    
  private
  
  def set_payment_method
    @payment_method = PaymentMethod.joins(:user_payment_methods).find_by(user_payment_methods: {id: params[:id]})
  end
  
end