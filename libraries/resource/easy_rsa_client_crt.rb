class ChefOpenvpn
  class Resource
    class EasyRsaClientCrt < ChefOpenvpn::Resource::EasyRsa
      include Openvpn

      resource_name :openvpn_easy_rsa_sclient_crt

      property :content, String, default: lazy { server_certs['crt'] }
    end
  end
end
