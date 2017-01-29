class SessionsController < ApplicationController
  def new
    self.resource = User.new(sign_in_params)
    render :sign_in
  end

  def sign_in
    # Call the API to sign-up the user
    response = { code: 200, user: params[:user] }

    set_flash_message!(:notice, :signed_in)

    if response[:code] == 200
      redirect_to root_path
    end
  end

  def sign_out
    # Call the API to sign-out the user
    response = { code: 200 }

    set_flash_message! :notice, :signed_out
    yield if block_given?
    respond_to_on_destroy
  end

  def sign_in_params
    parameter_sanitizer.sanitize(:sign_in)
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
