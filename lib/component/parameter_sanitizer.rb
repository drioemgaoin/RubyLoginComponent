module Component
  class ParameterSanitizer
    DEFAULT_PERMITTED_ATTRIBUTES = {
      sign_in: [:password, :remember_me],
      sign_up: [:password, :password_confirmation],
      account_update: [:password, :password_confirmation, :current_password]
    }

    def initialize(resource_class, resource_name, params)
      @auth_keys      = extract_auth_keys(resource_class)
      @params         = params
      @resource_name  = resource_name
      @permitted      = {}

      DEFAULT_PERMITTED_ATTRIBUTES.each_pair do |action, keys|
        permit(action, keys: keys)
      end
    end

    # Sanitize the parameters for a specific +action+.
    #
    # === Arguments
    #
    # * +action+ - A +Symbol+ with the action that the controller is
    #   performing, like +sign_up+, +sign_in+, etc.
    #
    # === Examples
    #
    #    # Inside the `RegistrationsController#create` action.
    #    resource = build_resource(devise_parameter_sanitizer.sanitize(:sign_up))
    #    resource.save
    #
    # Returns an +ActiveSupport::HashWithIndifferentAccess+ with the permitted
    # attributes.
    def sanitize(action)
      permissions = @permitted[action]

      if permissions.respond_to?(:call)
        cast_to_hash permissions.call(default_params)
      elsif permissions.present?
        cast_to_hash permit_keys(default_params, permissions)
      else
        unknown_action!(action)
      end
    end

    # Add or remove new parameters to the permitted list of an +action+.
    #
    # === Arguments
    #
    # * +action+ - A +Symbol+ with the action that the controller is
    #   performing, like +sign_up+, +sign_in+, etc.
    # * +keys:+     - An +Array+ of keys that also should be permitted.
    # * +except:+   - An +Array+ of keys that shouldn't be permitted.
    # * +block+     - A block that should be used to permit the action
    #   parameters instead of the +Array+ based approach. The block will be
    #   called with an +ActionController::Parameters+ instance.
    #
    # === Examples
    #
    #   # Adding new parameters to be permitted in the `sign_up` action.
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:subscribe_newsletter])
    #
    #   # Removing the `password` parameter from the `account_update` action.
    #   devise_parameter_sanitizer.permit(:account_update, except: [:password])
    #
    #   # Using the block form to completely override how we permit the
    #   # parameters for the `sign_up` action.
    #   devise_parameter_sanitizer.permit(:sign_up) do |user|
    #     user.permit(:email, :password, :password_confirmation)
    #   end
    #
    #
    # Returns nothing.
    def permit(action, keys: nil, except: nil, &block)
      if block_given?
        @permitted[action] = block
      end

      if keys.present?
        @permitted[action] ||= @auth_keys.dup
        @permitted[action].concat(keys)
      end

      if except.present?
        @permitted[action] ||= @auth_keys.dup
        @permitted[action] = @permitted[action] - except
      end
    end

    private

    # Cast a sanitized +ActionController::Parameters+ to a +HashWithIndifferentAccess+
    # that can be used elsewhere.
    #
    # Returns an +ActiveSupport::HashWithIndifferentAccess+.
    def cast_to_hash(params)
      # TODO: Remove the `with_indifferent_access` method call when we only support Rails 5+.
      params && params.to_h.with_indifferent_access
    end

    def default_params
      @params.fetch(@resource_name, {})
    end

    def permit_keys(parameters, keys)
      parameters.permit(*keys)
    end

    def extract_auth_keys(klass)
      puts klass.inspect
      auth_keys = klass.authentication_keys

      auth_keys.respond_to?(:keys) ? auth_keys.keys : auth_keys
    end

    def unknown_action!(action)
      raise NotImplementedError, <<-MESSAGE.strip_heredoc
        "Component doesn't know how to sanitize parameters for '#{action}'".
        If you want to define a new set of parameters to be sanitized use the
        `permit` method first:
          parameter_sanitizer.permit(:#{action}, keys: [:param1, :param2, :param3])
      MESSAGE
    end
  end
end
