class ChefOpenvpn
  class Resource
    class Config < Chef::Resource
      include OpenvpnHelper

      resource_name :openvpn_config

      default_action :create
      allowed_actions :create, :delete

      property :config, Hash
      property :content, [String,NilClass], default: lazy { to_conf }
      property :path, String

      def provider
        ChefOpenvpn::Provider::Config
      end

      private

      def to_conf
        ConfigGenerator.generate_config(config)
      end
    end
  end
end
