module Users
  class ParameterSanitizer < Devise::ParameterSanitizer
    def initialize(*)
      super
      permit(:account_update,
             keys: %i[email password password_confirmation first_name last_name])
    end
  end
end
