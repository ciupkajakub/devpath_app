require 'users/parameter_sanitizer'

class ApplicationController < ActionController::Base
  protected

  def current_user
    if devise_controller?
      @current_user ||= super
    else
      @current_user ||= super || Guest.new
    end
  end

  def devise_parameter_sanitizer
    if resource_class == User
      Users::ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end
end
