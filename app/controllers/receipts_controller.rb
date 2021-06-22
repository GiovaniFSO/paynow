class ReceiptsController < ApplicationController

  def show
    Payment.find_by(token: params[:token])
  end  
end