class ChefOpenvpn
  class Resource
    class ConfigClient < ChefOpenvpn::Resource::Config
      resource_name :openvpn_config_client

      property :path, String, desired_state: false,
                              default: lazy { Openvpn::CLIENT_CONFIG }
    end
  end
end
