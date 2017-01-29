class User < ApplicationRecord
  if respond_to?(:helper_method)
    helper_method "current_user", "user_signed_in?", "user_session"
  end

  def self.authentication_keys
    @authentication_keys ||= [:email]
  end

  def authenticate_user!(opts={})
    opts[:scope] = :user
  end

  def user_signed_in?
    !!current_user
  end

  def current_user
    @current_user
  end

  def user_session
    current_user
  end
end
