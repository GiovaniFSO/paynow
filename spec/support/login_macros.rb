module LooginMacros
  def admin_login(admin = Admin.create!(email: 'giovani@gmail.com', password: '123456'))  
    login_as admin, scope: :admin
    admin
  end
end