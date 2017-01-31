class ApplicationController < ActionController::Base

  if respond_to?(:helper_method)
    helpers = %w(resource scope_name resource_name resource_class resource_params current_user user_signed_in? user_session)
    helper_method(*helpers)
  end

  protect_from_forgery with: :exception

  def navigational_formats
    @navigational_formats ||= Component.navigational_formats.select { |format| Mime::EXTENSION_LOOKUP[format.to_s] }
  end

  def parameter_sanitizer
    @parameter_sanitizer ||= Component::ParameterSanitizer.new(resource_class, resource_name, params)
  end

  ActiveSupport.on_load(:action_controller) do
    include Component::Controllers::Helpers
  end

  def user_signed_in?
    authenticate?
  end

  protected

    def authenticate email
      session[:user_email] = email
    end

    def authenticate?
      !!session[:user_email]
    end

    def require_no_authentication
      return unless is_navigational_format?

      if authenticate?
        puts I18n.t("component.failure.already_authenticated")
        flash[:alert] = I18n.t("component.failure.already_authenticated")
        redirect_to root_path
      end
    end

    def resource=(new_resource)
      instance_variable_set(:"@#{resource_name}", new_resource)
    end

    def resource
      instance_variable_get(:"@#{resource_name}")
    end

    def resource_name
      :user
    end
    alias :scope_name :resource_name

    def resource_params
      params.fetch(resource_name, {})
    end

    def to
      ActiveSupport::Dependencies.constantize("User")
    end

    def resource_class
	    User
	  end

    def is_flashing_format?
      is_navigational_format?
    end

    def is_navigational_format?
      Component.navigational_formats.include?(request_format)
    end

    def request_format
      @request_format ||= request.format.try(:ref)
    end

    def self.authentication_keys
      @authentication_keys ||= [:email]
    end

    def set_flash_message(key, kind, options = {})
      message = find_message(kind, options)

      if options[:now]
        flash.now[key] = message if message.present?
      else
        flash[key] = message if message.present?
      end
    end
    helper_method :set_flash_message

    def set_flash_message!(key, kind, options = {})
      if is_flashing_format?
        set_flash_message(key, kind, options)
      end
    end
    helper_method :set_flash_message

    def resource_params
      params.fetch(resource_name, {})
    end
    helper_method :resource_params

    def find_message(kind, options = {})
      options[:scope] ||= translation_scope
      options[:default] = Array(options[:default]).unshift(kind.to_sym)
      options[:resource_name] ||= resource_name
      options = component_i18n_options(options)
      I18n.t("#{options[:resource_name]}.#{kind}", options)
    end
    helper_method :find_message

    def translation_scope
      "component.#{controller_name}"
    end

    def component_i18n_options(options)
      options
    end
end
