class ReceiptsController < ApplicationController
  layout 'public'
  
  def index
  end
  def show
    Payment.find_by(token: params[:token])
  end  
end