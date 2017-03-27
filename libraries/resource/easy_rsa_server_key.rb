class ChefOpenvpn
  class Resource
    class EasyRsaServerKey < ChefOpenvpn::Resource::EasyRsa
      resource_name :openvpn_easy_rsa_server_key

      property :content, String, default: lazy { server_certs['key'] }
    end
  end
end
