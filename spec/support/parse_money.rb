module ParseMoney
  def get_money(value)
    ActionController::Base.helpers.number_to_currency(value)
  end
end