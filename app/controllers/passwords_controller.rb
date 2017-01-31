class PasswordsController < ApplicationController
  def new
    self.resource = resource_class.new
  end

  def create
    self.resource = resource_class.new(password_params)
    response = HTTParty.post("http://localhost:4000/users/password", body: { user: resource.as_json })

    if response.success?
      authenticate(self.resource.email)
      set_flash_message!(:notice, :password)
      redirect_to root_path
    else
      set_flash_message :error, :invalid, { scope: "component", resource_name: "failure" }
    end
  end

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end

  def update
    puts "UPDATE PASSWORD"
  end

  def password_params
    params.require(:user).permit(:email)
  end
end
