module ConfigGenerator

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

module OpenvpnConfig
  BASE_PATH ||= '/etc/openvpn'
  SERVER_CONFIG ||= '/etc/openvpn/server.conf'
  CLIENT_CONFIG ||= '/etc/openvpn/client.conf'

  class EasyRsaHelper
    include Dbag

    ## structure
    # {
    #   'ca.key' => 'key',
    #   'ca.crt' => 'crt',
    #   'dh.pem' => 'dh',
    #   'servers' => {
    #     'server_name' => {
    #       'key' => 'key',
    #       'crt' => 'crt',
    #       'crs' => 'crs',
    #     }
    #   },
    #   'clients' => {
    #     'client_name' => {
    #       'key' => 'key',
    #       'crt' => 'crt',
    #       'crs' => 'crs'
    #       }
    #     }
    #   }
    # }


    def initialize(data_bag, data_bag_item, vars={})
      @dbag = Dbag::Keystore.new(data_bag, data_bag_item)
      @vars = vars
    end


    ## generate keys/ca.crt keys/ca.key. grab from data bag if it is there
    ## create if it doesn't exist and write to data bag
    def generate_ca_cert
      ca_crt = @dbag.get('ca.crt')
      ca_key = @dbag.get('ca.key')

      Dir.chdir(cadir)
      if ca_crt.nil? || ca_key.nil?
        shell_out!("/bin/sh pkitool --initca")

        ca_crt = ::File.read(::File.join('keys', 'ca.crt'))
        ca_key = ::File.read(::File.join('keys', 'ca.key'))

        @dbag.put('ca.crt', ca_crt)
        @dbag.put('ca.key', ca_key)

        ## server and client keys won't work after this. remove them
        @dbag.delete('servers')
        @dbag.delete('clients')
      else

        ## these are needed to create server and client keys
        ::File.write(::File.join('keys', 'ca.crt'), ca_crt)
        ::File.write(::File.join('keys', 'ca.key'), ca_key)
      end

      return ca_crt
    end


    ## generate dh.pem
    def generate_dh
      dh_pem = @dbag.get('dh.pem')

      Dir.chdir(cadir)
      if dh_pem.nil?
        shell_out!("/bin/sh build-dh")

        dh_pem = ::File.read(::File.join('keys', 'dh2048.pem'))
        @dbag.put('dh.pem', dh_pem)
      else
        ::File.write(::File.join('keys', 'dh2048.pem'), dh_pem)
      end
    end


    ## generate server.key, server.crt
    def generate_server_cert(name)
      servers = @dbag.get("servers") || {}

      servers[name] ||= {}
      server = servers[name]
      if server["key"].nil? || server["crt"].nil? || server["csr"].nil?

        Dir.chdir(cadir)
        shell_out!("pkitool --server #{name}")

        server["key"] = ::File.read(::File.join('keys', "#{name}.crt"))
        server["crt"] = ::File.read(::File.join('keys', "#{name}.csr"))
        server["csr"] = ::File.read(::File.join('keys', "#{name}.key"))

        @dbag.put("servers", servers)
      end

      cleanup
      return server
    end


    ## generate client.key, client.crt
    def generate_client_cert(name)
      clients = @dbag.get("clients") || {}

      clients[name] ||= {}
      client = clients[name]
      if client["key"].nil? || client["crt"].nil? || client["csr"].nil?

        Dir.chdir(cadir)
        shell_out!("pkitool --client #{name}")

        client["key"] = ::File.read(::File.join('keys', "#{name}.crt"))
        client["crt"] = ::File.read(::File.join('keys', "#{name}.csr"))
        client["csr"] = ::File.read(::File.join('keys', "#{name}.key"))

        @dbag.put("clients", clients)
      end

      cleanup
      return client
    end



    private

    def cleanup
      if ::File.directory?(cadir)
        ::FileUtils.rm_rf(cadir)
      end
    end

    def cadir
      return @cadir unless @cadir.nil?

      @cadir = ::File.join(Chef::Config[:cache_file_path], 'openvpn')
      shell_out!("make-cadir #{@cadir}")
      ## need to link openssl-*.cnf to openssl.cnf so that build-ca can find it.
      ## find latest version
      openssl_confs = []
      ::Dir.entries(cadir).each do |e|
        openssl_confs << e if e =~ /^openssl-*.cnf$/
      end
      ::File.link(openssl.sort.last, 'openssl.cnf')

      shell_out!("source vars")

      ## override any vars sourced with argument
      shell_out!("/bin/sh clean-all",
        env: @vars
      )
      return @cadir
    end
  end
end


class Chef::Recipe
  include OpenvpnConfig
end
