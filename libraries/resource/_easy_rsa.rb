class ChefOpenvpn
  class Resource
    class EasyRsa < Chef::Resource
      include OpenvpnConfig

      resource_name :openvpn_easy_rsa

      default_action :create
      allowed_actions :create, :create_if_missing, :delete

      property :exists, [TrueClass, FalseClass]

      property :data_bag, String
      property :data_bag_item, String
      property :key, String

      property :cert_variables, Hash, default: {}

      property :content, String
      property :path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnConfig::BASE_PATH, name) }

      def provider
        ChefOpenvpn::Provider::Credentials
      end

      private

      def easy_rsa
        @easy_rsa ||= EasyRsaHelper.new(data_bag, data_bag_item, cert_variables)
      end

      def ca_crt
        easy_rsa.generate_ca_cert
      end

      def dh
        easy_rsa.generate_dh
      end

      def server_certs
        easy_rsa.generate_server_cert(key)
      end

      def client_certs
        easy_rsa.generate_client_cert(key)
      end
    end
  end
end
