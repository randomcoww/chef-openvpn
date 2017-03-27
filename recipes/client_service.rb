service "openvpn@#{::File.basename(Openvpn::CLIENT_CONFIG, '.conf')}" do
  action [:enable, :start]
end
