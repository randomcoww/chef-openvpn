include_recipe "openvpn::systemd_unit"

service "openvpn@#{::File.basename(OpenvpnHelper::SERVER_CONFIG, '.conf')}" do
  action [:enable, :start]
end
