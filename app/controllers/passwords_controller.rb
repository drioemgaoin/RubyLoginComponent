class PasswordsController < ApplicationController
  def new
    self.resource = resource_class.new
  end

  def create
    self.resource = resource_class.new(password_params)
    response = HTTParty.post("http://localhost:4000/users/password", body: { user: resource.as_json })

    if response.success?
      set_flash_message!(:notice, :password)
      redirect_to new_sign_in_path
    else
      parsed_response = JSON.parse(response.body ,:symbolize_names => true)
      flash[:error] = parsed_response[:errors].map{ |k, v|  "#{k} #{v[0]}".camelize }.join('\r\n')
      render :new
    end
  end

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end

  def update
    self.resource = resource_class.new(change_password_params)
    response = HTTParty.patch("http://localhost:4000/users/password", body: { user: resource.as_json })

    if response.success?
      set_flash_message!(:notice, :updated)
      redirect_to new_sign_in_path
    else
      parsed_response = JSON.parse(response.body ,:symbolize_names => true)
      flash[:error] = parsed_response[:errors].map{ |k, v|  "#{k} #{v[0]}".camelize }.join('\r\n')
      render :edit
    end
  end

  def password_params
    params.require(:user).permit(:email)
  end

  def change_password_params
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end
end
