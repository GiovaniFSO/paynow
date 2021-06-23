module ApplicationHelper
  def active(button)
    return 'active' if !request.params.has_key?(:filter) && button == 'last_30_days'
    
    request.params[:filter] == button ? 'active' : ''
  end
end
