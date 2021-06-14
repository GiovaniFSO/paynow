class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource.class.name == 'User'
        byebug
      stored_location_for(resource) || welcome_path
    end
  end  
end
