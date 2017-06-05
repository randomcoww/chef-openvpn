class ChefOpenvpn
  class Resource
    class CredentialsConfig < ChefOpenvpn::Resource::Config
      include Dbag

      resource_name :openvpn_credentials_config

      property :data_bag, String
      property :data_bag_item, String
      property :key, String

      property :path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnHelper::BASE_PATH, name) }

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
