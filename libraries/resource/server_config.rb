class ChefOpenvpn
  class Resource
    class ServerConfig < ChefOpenvpn::Resource::Config
      resource_name :openvpn_server_config

      property :path, String, desired_state: false,
                              default: lazy { OpenvpnServer::CONFIG_PATH }
    end
  end
end
