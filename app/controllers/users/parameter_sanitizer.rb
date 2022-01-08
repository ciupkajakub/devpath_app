class Users::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:account_update, keys: [:email, :password, :password_confirmation, :first_name, :last_name])
  end
end
