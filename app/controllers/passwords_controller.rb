class PasswordsController < ApplicationController
  def new
    self.resource = resource_class.new
  end

  def create
    puts "FORGOT PASSWORD"
  end
end
