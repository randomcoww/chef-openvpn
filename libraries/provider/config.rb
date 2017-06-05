class ChefOpenvpn
  class Provider
    class Config < Chef::Provider
      provides :openvpn_config, os: "linux"

      def load_current_resource
        @current_resource = ChefOpenvpn::Resource::Config.new(new_resource.name)

        if ::File.exists?(new_resource.path)
          current_resource.content(::File.read(new_resource.path).chomp)
        else
          current_resource.content(nil)
        end

        current_resource
      end

      def action_create_if_missing
        converge_by("Create OpenVPN config: #{new_resource}") do
          openvpn_config.run_action(:create)
        end if current_resource.content.nil?
      end

      def action_create
        converge_by("Create OpenVPN config: #{new_resource}") do
          openvpn_config.run_action(:create)
        end if current_resource.content.nil? || current_resource.content != new_resource.content.chomp
      end

      def action_delete
        converge_by("Delete OpenVPN config: #{new_resource}") do
          openvpn_config.run_action(:delete)
        end if !current_resource.content.nil?
      end

      private

      def openvpn_config
        @openvpn_config ||= Chef::Resource::File.new(new_resource.path, run_context).tap do |r|
          r.path new_resource.path
          r.sensitive true
          r.content new_resource.content.chomp
        end
      end
    end
  end
end
