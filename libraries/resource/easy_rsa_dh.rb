class ChefOpenvpn
  class Resource
    class EasyRsaDh < ChefOpenvpn::Resource::EasyRsa
      resource_name :openvpn_easy_rsa_dh

      property :content, String, default: lazy { dh }
    end
  end
end
