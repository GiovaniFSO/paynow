class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource.class.name == 'User'
      return new_user_company_path if resource.company_id.blank?
      stored_location_for(resource) || root_path
    else
      stored_location_for(resource) || '/admin'
    end
  end  
end
