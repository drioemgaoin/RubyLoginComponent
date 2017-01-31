class User
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :password, :password_confirmation, :reset_password_token

  validates_presence_of :email

  def initialize(attributes = {})
    attributes.each do |key, value|
      self.send(:"#{key}=", value)
    end
  end

  def persisted?
    false
  end
end
