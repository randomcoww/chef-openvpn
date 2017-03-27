class ChefOpenvpn
  class Resource
    class EasyRsaClientCrt < ChefOpenvpn::Resource::EasyRsa
      resource_name :openvpn_easy_rsa_client_crt

      property :content, String, default: lazy { client_certs['crt'] }
    end
  end
end
