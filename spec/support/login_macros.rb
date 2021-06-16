module LooginMacros
  def admin_login(admin = Admin.create!(email: 'giovani@paynow.com.br', password: '123456'))  
    login_as admin, scope: :admin
    admin
  end

  def user_login(user = User.create!(email: 'giovani@codeplay.com.br', password: '123456'))  
    login_as user, scope: :user
    user
  end
end