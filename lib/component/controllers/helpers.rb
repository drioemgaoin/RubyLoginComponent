module Component
  module Controllers
    module Helpers
      puts "LOAD HELPER----------------------"
      def after_sign_out_path_for(resource_or_scope)
        # scope = Devise::Mapping.find_scope!(resource_or_scope)
        # router_name = Devise.mappings[scope].router_name
        # context = router_name ? send(router_name) : self
        # context.respond_to?(:root_path) ? context.root_path : "/"
        "/"
      end
    end
  end
end
