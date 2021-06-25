class User::CompaniesController < ApplicationController
  before_action :set_user  

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    Company.transaction do 
      if @company.save
        @user.company_id = @company.id
        @user.administrador!
        @user.save
        redirect_to user_dashboard_index_path
      else
        render :new  
      end
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def company_params
    params.require(:company).permit(:cnpj, :name, :email, :address)
  end
end