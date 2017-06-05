class ChefOpenvpn
  class Resource
    class Cert < Chef::Resource
      resource_name :openvpn_cert

      default_action :create_if_missing
      allowed_actions :create_if_missing, :create

      property :data_bag, String
      property :data_bag_item, String

      property :root_subject, Array
      property :subject, Array

      property :alt_names, Hash, default: {}
      property :extensions, Hash, default: {}

      property :key_path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnHelper::BASE_PATH, "#{name}.key") }
      property :cert_path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnHelper::BASE_PATH, "#{name}.crt") }

      def provider
        ChefOpenvpn::Provider::Cert
      end
    end
  end
end
