class ChefOpenvpn
  class Resource
    class Config < Chef::Resource
      include OpenvpnConfig

      resource_name :openvpn_config

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]
      property :config, Hash
      property :content, String, default: lazy { to_conf }
      property :path, String

      def provider
        ChefOpenvpn::Provider::Config
      end

      private

      def to_conf
        generate_config(config)
      end
    end
  end
end
