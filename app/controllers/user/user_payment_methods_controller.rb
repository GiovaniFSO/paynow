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
        errors_messages(@user_payment_method)
        render :new  
      end
    end
  end

  def edit
    @user_payment_method = UserPaymentMethod.find(params[:id])
    @payment_method = PaymentMethod.find(params[:payment_method_id])
  end

  def update
    @user_payment_method = UserPaymentMethod.find(params[:id])
    @user_payment_method.transaction do 
      @user_payment_method.kind.update!(params_permit)
    end
    redirect_to @user_payment_method, notice: 'Atualizado com sucesso'
  rescue ActiveRecord::RecordInvalid => exception
    #flash[:alert] = exception.message
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    errors_messages(@user_payment_method)
    render :edit
  end

  private   

  def user_payment_method_params
    { payment_method_id: params[:payment_method_id], user_id: current_user.id, kind: save_details }
  end
  
  def params_permit
    if params.include?('pix')
      params.require(:pix).permit(:key, :bank_code)
    elsif params.include?('boleto')
      params.require(:boleto).permit(:bank_code, :account, :agency)
    elsif params.include?('credit_card')
      params.require(:credit_card).permit(:account)
    end
  end

  def save_details    
    if params.include?('pix')
      Pix.create(params_permit)
    elsif params.include?('boleto')
      Boleto.create(params_permit)  
    elsif params.include?('credit_card')
      CreditCard.create(params_permit)
    end
  end

  def errors_messages(user_payment_method)
    if user_payment_method.payment_method.kind == 'pix'
      flash[:alert] = 'Chave Pix ou código de banco inválido'
    elsif user_payment_method.payment_method.kind == 'boleto'
      flash[:alert] = 'Código de banco, agência, ou conta bancária inválido'
    else
      flash[:alert] = 'Numero do cartão inválido'
    end
  end
end