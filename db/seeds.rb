if Rails.env.development?
  Admin.create!(
    email: 'admin@admin.com',
    password: 'password',
    password_confirmation: 'password'
  )
end
