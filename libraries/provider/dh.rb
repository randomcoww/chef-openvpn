class ChefOpenvpn
  class Provider
    class Dh < Chef::Provider
      include OpenSSLHelper

      provides :openvpn_dh, os: "linux"

      def load_current_resource
        @current_resource = ChefOpenvpn::Resource::Dh.new(new_resource.name)
        current_resource
      end


      def action_create
        converge_by("Create OpenVPN DH file: #{new_resource}") do
          create_base_path

          cert_file.run_action(:create)
        end
      end

      def action_create_if_missing
        if !::File.exist?(new_resource.cert_path)
          action_create
        end
      end


      private

      def create_base_path
        Chef::Resource::Directory.new(::File.dirname(new_resource.cert_path), run_context).tap do |r|
          r.recursive true
        end.run_action(:create)
      end

      def cert_file
        @cert_file ||= Chef::Resource::File.new(new_resource.cert_path, run_context).tap do |r|
          r.path new_resource.cert_path
          r.sensitive true
          r.content OpenSSLHelper::CertGenerator.generate_dn.to_pem.chomp
        end
      end
    end
  end
end
