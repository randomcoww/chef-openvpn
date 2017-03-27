service "openvpn@#{::File.basename(Openvpn::SERVER_CONFIG, '.conf')}" do
  action [:enable, :start]
end
