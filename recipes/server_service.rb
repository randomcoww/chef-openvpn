service "openvpn@#{::File.basename(OpenvpnServer::CONFIG_PATH, '.conf')}" do
  action [:enable, :start]
end
