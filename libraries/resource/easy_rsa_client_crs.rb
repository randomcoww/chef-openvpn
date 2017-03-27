class ChefOpenvpn
  class Resource
    class EasyRsaClientCrs < ChefOpenvpn::Resource::EasyRsa
      include Openvpn

      resource_name :openvpn_easy_rsa_sclient_crs

      property :content, String, default: lazy { server_certs['crs'] }
    end
  end
end
