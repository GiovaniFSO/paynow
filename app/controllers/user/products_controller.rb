class User::ProductsController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: %i[update]
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

  def edit
    @product = Product.find(params[:id])
    @payment_methods = UserPaymentMethod.joins(:payment_method)
                                        .includes(:payment_method)
                                        .where(user_id: 1, payment_method: {active: true}).distinct
                                        .map{ |method| ["#{method.payment_method[:kind]} - #{method.payment_method[:name]}", method.id]}   
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to [:user, @product], notice: 'Atualizado com sucesso'
    else
      render :edit  
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