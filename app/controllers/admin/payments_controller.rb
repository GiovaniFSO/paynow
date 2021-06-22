class Admin::PaymentsController < ApplicationController

  def index
    @orders = Order.all #.where(status: Order.status[:pendente])
  end
end