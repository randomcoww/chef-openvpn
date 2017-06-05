class ChefOpenvpn
  class Resource
    class ClientCert < ChefOpenvpn::Resource::Cert
      resource_name :openvpn_client_cert

      property :extensions, Hash, default: {
        "basicConstraints" => "CA:FALSE",
        "extendedKeyUsage" => 'clientAuth',
      }

      property :generate_type, String, default: 'node_cert'
    end
  end
end
