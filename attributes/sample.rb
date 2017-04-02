node.default['openvpn']['pkg_update_command'] = "apt-get update -qqy"
node.default['openvpn']['pkg_names'] = ['openvpn', 'easy-rsa', 'procps']

node.default['openvpn']['sample_server'] = {
  'config' => {
    "port" => 1194,
    "proto" => "udp",
    "dev" => "tap",
    "tls-server" => true,
    "mode" => "server",
    "keepalive" => [10, 120],
    "comp-lzo" => true,
    "user" => "nobody",
    "group" => "nogroup",
    "persist-key" => true,
    "cipher" => "AES-256-CBC",
    "auth" => "SHA512",
    "verb" => 3,
    "ca" => 'ca.crt',
    "cert" => 'server.crt',
    "key" => 'server.key',
    "dh" => 'dh'
  },
  'data_bag' => 'deploy_config',
  'data_bag_item' => 'openvpn_server',
  'label' => 'default',
  'cert_variables' => {
    "KEY_COUNTRY" => "XX",
    "KEY_PROVINCE" => "YY",
    "KEY_CITY" => "BlahCity",
    "KEY_ORG" => "BlahOrg",
    "KEY_EMAIL" => "blah@test.local",
    "KEY_OU" => "BlahOU"
  }
}

node.default['openvpn']['sample_client'] = {
  'config' => {
    "client" => true,
    "dev" => "tun",
    "proto" => "udp",
    "remote" => ["us-seattle.privateinternetaccess.com", 1194],
    "resolv-retry" => "infinite",
    "nobind"  => true,
    "persist-key" => true,
    "ca" => 'ca.crt',
    "tls-client" => true,
    "remote-cert-tls" => "server",
    "auth-user-pass" => 'client_auth',
    "comp-lzo" => true,
    "verb" => 3,
    "reneg-sec" => 0,
    "cipher" => "BF-CBC",
    "keepalive" => [10, 30],
    "route-nopull" => true,
    "redirect-gateway" => true,
    "fast-io" => true,
  },
  'auth-user-pass' => {
    'data_bag' => 'deploy_config',
    'data_bag_item' => 'openvpn_pia_v2',
    'key' => 'auth-user-pass'
  },
  'ca' => {
    'data_bag' => 'deploy_config',
    'data_bag_item' => 'openvpn_pia_v2',
    'key' => 'ca.crt'
  }
}
