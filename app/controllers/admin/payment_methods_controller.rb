class Admin::PaymentMethodsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_payment_method, only: %i[show update edit destroy]

  def index
    @payment_methods = PaymentMethod.all
  end  
  
  def show; end
  
  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      redirect_to [:admin, @payment_method]
    else
      render :new  
    end
  end

  def edit; end

  def update
    @payment_method.update(payment_method_params)
    redirect_to [:admin, @payment_method], notice: 'Atualizado com sucesso'
  end

  def destroy
    @payment_method.destroy
    redirect_to admin_payment_methods_path, notice: 'Meio de pagamento deletado com sucesso'
  end

  private

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  def payment_method_params
    params.require(:payment_method).permit(:kind, :name, :fee, :max_fee, :active, :icon)
  end
end