## rewrite to add some dependency and always restart
## chef systemd_unit doesn't support drop-in as far as i can tell

systemd_resource_dropin "10-restart" do
  service "openvpn@.service"
  config ({
    'Service' => {
      'Restart' => 'always',
      'RestartSec' => 5,
    }
  })
  action [:create]
end
