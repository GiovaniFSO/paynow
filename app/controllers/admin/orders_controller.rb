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
    order = Order.find(params[:id])
    order.transaction do 
      order.payments.new(date: DateTime.current, status_bank: bank_params[:status_bank], status: Payment.status[:rejeitado])
      order.pendente!
      redirect_to [:admin, order]
    end
  end

  private

  def bank_params
    params.permit(:status_bank)
  end
end