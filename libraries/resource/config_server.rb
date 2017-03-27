class ChefOpenvpn
  class Resource
    class ConfigServer < ChefOpenvpn::Resource::Config
      resource_name :openvpn_config_server

      property :path, String, desired_state: false,
                              default: lazy { OpenvpnConfig::SERVER_CONFIG }
    end
  end
end
