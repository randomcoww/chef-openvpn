package 'procps' do
  action :upgrade
end

instance_name = "openvpn_client"

start_command = <<-EOF
start-stop-daemon --start \
  --group nogroup \
  --quiet --oknodo \
  --pidfile /run/#{instance_name}.pid \
  --exec /usr/sbin/openvpn -- \
  --writepid /run/#{instance_name}.pid \
  --cd #{::File.dirname(OpenvpnHelper::CLIENT_CONFIG)} \
  --config #{OpenvpnHelper::CLIENT_CONFIG} \
  --daemon ovpn-#{instance_name}
EOF

stop_command = <<-EOF
start-stop-daemon --stop --quiet --oknodo \
  --pidfile /run/#{instance_name}.pid --retry 10
EOF

restart_command = <<-EOF
#{stop_command}
#{start_command}
EOF

status_command = <<-EOF
. /lib/lsb/init-functions
status_of_proc -p /run/#{instance_name}.pid openvpn "VPN '#{instance_name}'"
EOF

service 'openvpn' do
  start_command start_command
  stop_command stop_command
  restart_command restart_command
  status_command status_command
  action [:start]
end
