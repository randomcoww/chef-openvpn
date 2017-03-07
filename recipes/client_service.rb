service "openvpn@#{::File.basename(OpenvpnClient::CONFIG_PATH, '.conf')}" do
  action [:enable, :start]
end
