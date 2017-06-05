class ChefOpenvpn
  class Resource
    class ClientConfig < ChefOpenvpn::Resource::Config
      resource_name :openvpn_client_config

      property :path, String, desired_state: false,
                              default: lazy { OpenvpnHelper::CLIENT_CONFIG }
    end
  end
end
