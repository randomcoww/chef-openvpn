class ChefOpenvpn
  class Resource
    class ClientCredentials < ChefOpenvpn::Resource::Credentials
      resource_name :openvpn_client_credentials

      property :path, String, desired_state: false,
                default: lazy { ::File.join(::File.dirname(OpenvpnClient::CONFIG_PATH), name) }
    end
  end
end
