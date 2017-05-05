include_recipe "openvpn::systemd_unit"

service "openvpn@#{::File.basename(OpenvpnConfig::CLIENT_CONFIG, '.conf')}" do
  action [:enable, :start]
end
