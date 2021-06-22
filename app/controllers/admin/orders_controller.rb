class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end  

  def approved
    order = Order.find(params[:id])
    order.transaction do 
      order.payments.new(date: DateTime.current, status_bank: Payment.status_banks[:cobranca_efetivada_com_sucesso], 
                         status: Payment.status[:aprovado])
      order.aprovada!
      redirect_to [:admin, order]
    end
  end

  def reject
  end
end