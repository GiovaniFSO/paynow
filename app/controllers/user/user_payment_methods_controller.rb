class User::UserPaymentMethodsController < ApplicationController

  def new
    @user_payment_method = UserPaymentMethod.new
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end  

  def create
    UserPaymentMethod.transaction do 
      @user_payment_method = UserPaymentMethod.new(user_payment_method_params)
      
      if @user_payment_method.save
        @payment_method = @user_payment_method.payment_method_id
        redirect_to @user_payment_method
      else
        @payment_method = PaymentMethod.find(params[:payment_method_id])

        if @user_payment_method.payment_method.kind == 'pix'
          flash[:alert] = 'Chave Pix ou código de banco inválido'
        elsif @user_payment_method.payment_method.kind == 'boleto'
          flash[:alert] = 'Código de banco, agência, ou conta bancária inválido'
        else
          flash[:alert] = 'Numero do cartão inválido'
        end
        render :new  
      end
    end
  end

  private   

  def user_payment_method_params
    { payment_method_id: params[:payment_method_id], user_id: current_user.id, kind: save_details }
  end
  
  
  def save_details    
    case params.keys[0]
    when 'pix'
      Pix.create(params.require(:pix).permit(:key, :bank_code))
    when 'boleto'
      Boleto.create(params.require(:boleto).permit(:bank_code, :account, :agency))  
    when 'credit_card'
      CreditCard.create(params.require(:credit_card).permit(:account))
    end
  end
end