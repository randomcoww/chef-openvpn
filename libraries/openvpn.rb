module ConfigGenerator
  ## convert hash to yaml like config that unbound and nsd use

  ## sample source config
  # {
  #   "client" => true
  #   "dev" => "tun0"
  #   "proto" => "udp"
  #   "remote" => ["server.test.tld", 1194]
  #   "resolv-retry" => "infinite"
  #   "nobind"  => true
  #   "persist-key" => true
  #   "persist-tun" => true
  #   "ca" => "ca.crt"
  #   "tls-client" => true
  #   "remote-cert-tls" => "server"
  #   "auth-user-pass" => "auth.conf"
  #   "comp-lzo" => true
  #   "verb" => 3
  #   "reneg-sec" => 0
  #   "cipher" => "BF-CBC"
  #   "keepalive" => [10, 30]
  #   "route-nopull" => true
  #   "redirect-gateway" => true
  #   "fast-io" => true
  # }


  def generate_config(config_hash)
    out = []

    config_hash.each do |k, v|
      case v
      when Array
        out << ([k] + v).join(' ')
      when String,Integer
        out << [k, v].join(' ')
      when TrueClass
        out << k
      end
    end
    return out.join($/)
  end
end

module OpenvpnClient
  CONFIG_PATH ||= '/etc/openvpn/client/client.conf'
end

module OpenvpnServer
  CONFIG_PATH ||= '/etc/openvpn/server/server.conf'
end

class Chef::Recipe
  include OpenvpnClient
  include OpenvpnServer
end
