class ChefOpenvpn
  class Resource
    class Credentials < Chef::Resource
      include Dbag

      resource_name :openvpn_credentials

      default_action :create
      allowed_actions :create, :delete

      property :exists, [TrueClass, FalseClass]

      property :data_bag, String
      property :data_bag_item, String
      property :key, Array, default: []

      property :content, String, default: lazy { to_conf }
      property :path, String

      private

      def to_conf
        rndc_keys = []

        resource = Dbag::Keystore.new(
          data_bag,
          data_bag_item
        )
        resource.get(name)

        rndc_key_names.sort.each do |k|
          rndc_keys << {
            'name' => k,
            'secret' => keys_resource.get_or_create(k, SecureRandom.base64)
          }.merge(key_options)
        end

        generate_config({'key' => rndc_keys})
      end
    end
  end
end
