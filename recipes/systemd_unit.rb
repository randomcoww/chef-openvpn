## rewrite to add some dependency and always restart
## chef systemd_unit doesn't support drop-in as far as i can tell

systemd_unit "openvpn@.service" do
  content ({
    'Unit' => {
      'Description' => 'OpenVPN connection to %i',
      'After' => 'network-online.target'
    },
    'Service' => {
      'Restart' => 'always',
      'RestartSec' => 5,
      "PrivateTmp" => true,
      "KillMode" => "mixed",
      "Type" => "forking",
      "ExecStart" => "/usr/sbin/openvpn --daemon ovpn-%i --status /run/openvpn/%i.status 10 --cd /etc/openvpn --config /etc/openvpn/%i.conf --writepid /run/openvpn/%i.pid",
      "PIDFile" => "/run/openvpn/%i.pid",
      "ExecReload" => "/bin/kill -HUP $MAINPID",
      "WorkingDirectory" => "/etc/openvpn",
      "ProtectSystem" => "yes",
      "CapabilityBoundingSet" => "CAP_IPC_LOCK CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW CAP_SETGID CAP_SETUID CAP_SYS_CHROOT CAP_DAC_READ_SEARCH CAP_AUDIT_WRITE",
      "LimitNPROC" => 10,
      "DeviceAllow" => "/dev/null rw",
      "DeviceAllow" => "/dev/net/tun rw"
    },
    'Install' => {
      'WantedBy' => 'multi-user.target'
    }
  })
  action [:create]
end
