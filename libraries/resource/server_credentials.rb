class ChefOpenvpn
  class Resource
    class ServerCredentials < ChefOpenvpn::Resource::Credentials
      resource_name :openvpn_server_credentials

      property :path, String, desired_state: false,
                default: lazy { ::File.join(::File.dirname(OpenvpnServer::CONFIG_PATH), name) }
    end
  end
end
