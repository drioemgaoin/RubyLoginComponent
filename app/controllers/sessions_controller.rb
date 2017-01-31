class SessionsController < ApplicationController
  prepend_before_action :require_no_authentication, only: [:new]
  prepend_before_action :verify_signed_out_user, only: :destroy

  def new
    response = HTTParty.get("http://localhost:4000/users/sign_in")

    if response.success?
      self.resource = User.new
      render :sign_in
    end
  end

  def sign_in
    self.resource = User.new(sign_in_params)
    response = HTTParty.post("http://localhost:4000/users/sign_in", body: { user: resource.as_json })

    if response.success?
      authenticate(self.resource.email)
      set_flash_message!(:notice, :signed_in)
      redirect_to root_path
    else
      set_flash_message :error, :invalid, { scope: "component", resource_name: "failure" }
    end
  end

  def sign_out
    response = HTTParty.delete("http://localhost:4000/users/sign_out")

    if response.success?
      authenticate(nil)
      set_flash_message! :notice, :signed_out
      respond_to_on_destroy
    end
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  private
    def verify_signed_out_user
      if authenticate?
        set_flash_message! :notice, :already_signed_out
        respond_to_on_destroy
      end
    end

    def respond_to_on_destroy
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      end
    end

end
