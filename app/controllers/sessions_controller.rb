class SessionsController < ApplicationController
  def new
    response = HTTParty.get("http://localhost:4000/users/sign_in")

    if response.success?
      self.resource = User.new
      render :sign_in
    end
  end

  def sign_in
    self.resource = User.new(sign_in_params)
    response = HTTParty.post("http://localhost:4000/users/sign_in", body: { user: resource })

    if response.success?
      set_flash_message!(:notice, :signed_in)
      redirect_to root_path
    end
  end

  def sign_out
    response = HTTParty.delete("http://localhost:4000/users/sign_out")

    if response.success?
      set_flash_message! :notice, :signed_out
      respond_to_on_destroy
    end
  end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

  private
    def verify_signed_out_user
      if all_signed_out?
        set_flash_message! :notice, :already_signed_out
        respond_to_on_destroy
      end
    end

    def all_signed_out?
      # users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }
      # users.all?(&:blank?)
      true
    end

    def respond_to_on_destroy
      # We actually need to hardcode this as Rails default responder doesn't
      # support returning empty response on GET request
      respond_to do |format|
        format.all { head :no_content }
        format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      end
    end

end
