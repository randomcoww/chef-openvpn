class ChefOpenvpn
  class Resource
    class EasyRsaServerCrs < ChefOpenvpn::Resource::EasyRsa
      include Openvpn

      resource_name :openvpn_easy_rsa_server_crs

      property :content, String, default: lazy { server_certs['crs'] }
    end
  end
end
