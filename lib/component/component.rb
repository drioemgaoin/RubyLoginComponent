module Component
  autoload :ParameterSanitizer, 'component/parameter_sanitizer'

  module Controllers
    autoload :Helpers, 'component/controllers/helpers'
  end

  mattr_accessor :authentication_keys
  @@authentication_keys = [:email]

  mattr_accessor :navigational_formats
  @@navigational_formats = ["*/*", :html]
end
