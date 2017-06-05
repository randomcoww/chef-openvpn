class ChefOpenvpn
  class Resource
    class Dh < Chef::Resource
      resource_name :openvpn_dh

      default_action :create_if_missing
      allowed_actions :create_if_missing, :create

      property :cert_path, String, desired_state: false,
                              default: lazy { ::File.join(OpenvpnHelper::BASE_PATH, "#{name}.pem") }
    end
  end
end
