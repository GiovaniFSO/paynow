class Admin::PaymentsController < ApplicationController

  def index
    @orders = Order.where(status: Order.status[:pendente])
  end
end