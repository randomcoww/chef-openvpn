class ChefOpenvpn
  class Resource
    class EasyRsaClientKey < ChefOpenvpn::Resource::EasyRsa
      resource_name :openvpn_easy_rsa_client_key

      property :content, String, default: lazy { server_certs['key'] }
    end
  end
end
