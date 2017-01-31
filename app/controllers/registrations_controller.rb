class RegistrationsController < ApplicationController
  def new
    self.resource = User.new
  end

  def sign_up
    self.resource = User.new(sign_up_params)
    response = HTTParty.post("http://localhost:4000/users", body: { user: resource.as_json })

    if response.success?
      authenticate(self.resource.email)
      set_flash_message!(:notice, :signed_up)
      redirect_to root_path
    end
  end

  protected
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
