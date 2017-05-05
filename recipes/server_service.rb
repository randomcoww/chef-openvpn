include_recipe "chef-openvpn::systemd_unit"

service "openvpn@#{::File.basename(OpenvpnConfig::SERVER_CONFIG, '.conf')}" do
  action [:enable, :start]
end
