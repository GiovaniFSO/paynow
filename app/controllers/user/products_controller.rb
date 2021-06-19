class User::ProductsController < ApplicationController
  
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @payment_methods = UserPaymentMethod.joins(:payment_method)
                                        .includes(:payment_method)
                                        .where(user_id: 1, payment_method: {active: true}).distinct
                                        .map{ |method| ["#{method.payment_method[:kind]} - #{method.payment_method[:name]}", method.id]}                                        
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to [:user, @product]
    else
      @payment_methods = UserPaymentMethod.joins(:payment_method)
                                        .includes(:payment_method)
                                        .where(user_id: 1, payment_method: {active: true}).distinct
                                        .map{ |method| ["#{method.payment_method[:kind]} - #{method.payment_method[:name]}", method.id]}   
      render :new  
    end  
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :value, :discount, :user_payment_method_id).merge(user_id: current_user.id)
  end
end