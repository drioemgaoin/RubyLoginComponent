module Component
  module Controllers
    module Helpers
      def after_sign_out_path_for(resource_or_scope)
        self.respond_to?(:root_path) ? self.root_path : "/"
      end

      def parameter_sanitizer
        @parameter_sanitizer ||= Component::ParameterSanitizer.new(resource_class, resource_name, params)
      end
    end
  end
end
