class ChefOpenvpn
  class Resource
    class Credentials < Chef::Resource
      include Dbag

      resource_name :openvpn_credentials

      default_action :create
      allowed_actions :create, :create_if_missing, :delete

      property :exists, [TrueClass, FalseClass]

      property :data_bag, String
      property :data_bag_item, String
      property :key, String

      property :content, String, default: lazy { to_conf }
      property :path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnConfig::BASE_PATH, name) }

      private

      def to_conf
        content = Dbag::Keystore.new(
          data_bag,
          data_bag_item
        ).get(key)
        if content.is_a?(Array)
          content = content.join($/)
        end
        content
      end
    end
  end
end
