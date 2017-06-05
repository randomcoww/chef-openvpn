include_recipe "openvpn::systemd_unit"

service "openvpn@#{::File.basename(OpenvpnHelper::CLIENT_CONFIG, '.conf')}" do
  action [:enable, :start]
end
