class ChefOpenvpn
  class Resource
    class ServerConfig < ChefOpenvpn::Resource::Config
      resource_name :openvpn_server_config

      property :path, String, desired_state: false,
                              default: lazy { OpenvpnHelper::SERVER_CONFIG }
    end
  end
end
