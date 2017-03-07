class ChefOpenvpn
  class Provider
    class Credentials < Chef::Provider
      provides :openvpn_credentials, os: "linux"

      def load_current_resource
        @current_resource = ChefOpenvpn::Resource::Credentials.new(new_resource.name)

        current_resource.exists(::File.exist?(new_resource.path))

        if current_resource.exists
          current_resource.content(::File.read(new_resource.path).chomp)
        else
          current_resource.content('')
        end

        current_resource
      end

      def action_create
        converge_by("Create OpenVPN credentials file: #{new_resource}") do
          credentials_file.run_action(:create)
        end if !current_resource.exists || current_resource.content != new_resource.content
      end

      def action_delete
        converge_by("Delete OpenVPN credentials file: #{new_resource}") do
          credentials_file.run_action(:delete)
        end if current_resource.exists
      end

      private

      def credentials_file
        @unbound_config ||= Chef::Resource::File.new(new_resource.path, run_context).tap do |r|
          r.path new_resource.path
          r.sensitive true
          r.content new_resource.content
        end
      end
    end
  end
end
