class ChefOpenvpn
  class Resource
    class ServerCert < ChefOpenvpn::Resource::Cert
      resource_name :openvpn_server_cert

      property :extensions, Hash, default: {
        "basicConstraints" => "CA:FALSE",
        "keyUsage" => 'digitalSignature, keyEncipherment',
        "extendedKeyUsage" => 'serverAuth',
      }

      property :generate_type, String, default: 'node_cert'
    end
  end
end
