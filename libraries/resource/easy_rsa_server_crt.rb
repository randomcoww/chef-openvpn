class ChefOpenvpn
  class Resource
    class EasyRsaServerCrt < ChefOpenvpn::Resource::EasyRsa
      resource_name :openvpn_easy_rsa_server_crt

      property :content, String, default: lazy { server_certs['crt'] }
    end
  end
end
