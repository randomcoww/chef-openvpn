class ChefOpenvpn
  class Provider
    class DataBag < Chef::Provider
      include OpenVpnDataBag

      provides :openvpn_data_bag, os: "linux"

      def load_current_resource
        @current_resource = ChefOpenvpn::Resource::DataBag.new(new_resource.name)
        current_resource
      end

      def action_create_server
        converge_by("Create OpenVPN server data bag: #{new_resource}") do
          easy_rsa.generate_ca_cert
          easy_rsa.generate_dh
          easy_rsa.generate_server_cert(new_resource.name)
        end
      end

      def action_create_client
        converge_by("Delete OpenVPN client data bag: #{new_resource}") do
          easy_rsa.generate_ca_cert
          easy_rsa.generate_client_cert(new_resource.name)
        end
      end


      private

      def easy_rsa
        @easy_rsa ||= EasyRsa.new(
          new_resource.data_bag,
          new_resource.data_bag_item,
          new_resource.cert_variables
        )
      end
    end
  end
end
