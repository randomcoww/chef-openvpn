class ChefOpenvpn
  class Resource
    class DataBag < Chef::Resource
      resource_name :openvpn_data_bag

      default_action :create_sevrer
      allowed_actions :create_server, :create_client

      property :data_bag, Hash
      property :data_bag_item, String
      property :cert_variables, Hash
    end
  end
end
