require 'users/parameter_sanitizer'

class ApplicationController < ActionController::Base
  protected

  def devise_parameter_sanitizer
    if resource_class == User
      Users::ParameterSanitizer.new(User, :user, params)
    else
      super
    end
  end
end
