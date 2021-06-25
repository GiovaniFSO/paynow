class ReceiptsController < ApplicationController
  layout 'public'
  
  def index
    if params[:token_order]
      @payment = Payment.joins(:order)
                        .find_by(token: params[:token_order],
                                 orders: {status: 'aprovada'})

      @bank_code = Payment.status_banks[@payment.status_bank] if @payment
    end
  end

  def show
    Payment.find_by(token: params[:token])
  end  
end