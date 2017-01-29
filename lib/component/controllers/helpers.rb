module Component
  module Controllers
    module Helpers
      def after_sign_out_path_for(resource_or_scope)
        self.respond_to?(:root_path) ? self.root_path : "/"
      end
    end
  end
end
