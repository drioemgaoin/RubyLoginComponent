class RegistrationsController < ApplicationController
  def new
    self.resource = User.new
  end

  def sign_up
    puts "SIGN UP"
  end
end
