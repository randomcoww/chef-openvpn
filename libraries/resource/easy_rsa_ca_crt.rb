class ChefOpenvpn
  class Resource
    class EasyRsaCaCrt < ChefOpenvpn::Resource::EasyRsa
      include Openvpn

      resource_name :openvpn_easy_rsa_ca_crt

      property :content, String, default: lazy { ca_crt }
    end
  end
end
