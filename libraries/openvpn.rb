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

    include Chef::Mixin::ShellOut
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
      cert = prep_ca_cert

      return cert
    ensure
      cleanup
    end

    ## generate dh.pem
    def generate_dh
      prep_cadir

      dh_pem = @dbag.get('dh.pem')

      if dh_pem.nil?

        Dir.chdir(cadir)
        out = shell_out!("/bin/sh build-dh")

        dh_pem = ::File.read(::File.join('keys', 'dh2048.pem'))
        @dbag.put('dh.pem', dh_pem)
      end

      return dh_pem
    ensure
      cleanup
    end

    ## generate server.key, server.crt
    def generate_server_cert(name)
      prep_ca_cert

      cert = generate_cert("servers", name) {
        shell_out!("/bin/sh pkitool --server #{name}",
          env: @vars
        )}

      return cert
    ensure
      cleanup
    end

    ## generate client.key, client.crt
    def generate_client_cert(name)
      prep_ca_cert

      cert = generate_cert("clients", name) {
        shell_out!("/bin/sh pkitool #{name}",
          env: @vars
        )}

      return cert
    ensure
      cleanup
    end



    private

    ## user CA to generate server or client keys
    def generate_cert(type, name)
      certs = @dbag.get(type) || {}

      certs[name] ||= {}
      if certs[name]["key"].nil? || certs[name]["crt"].nil?

        Dir.chdir(cadir)
        yield

        certs[name]["key"] = ::File.read(::File.join('keys', "#{name}.key"))
        certs[name]["crt"] = ::File.read(::File.join('keys', "#{name}.crt"))

        @dbag.put(type, certs)
      end

      return certs[name]
    end

    ## create or get CA cert, leave files for use
    def prep_ca_cert
      prep_cadir

      ca_crt = @dbag.get('ca.crt')
      ca_key = @dbag.get('ca.key')

      if ca_crt.nil? || ca_key.nil?

        Dir.chdir(cadir)
        ## merge the extra env variables here
        out = shell_out!("/bin/sh pkitool --initca",
          env: @vars
        )

        ca_crt = ::File.read(::File.join('keys', 'ca.crt'))
        ca_key = ::File.read(::File.join('keys', 'ca.key'))

        @dbag.put('ca.crt', ca_crt)
        @dbag.put('ca.key', ca_key)

        ## server and client keys won't work after this. remove them
        @dbag.delete('servers')
        @dbag.delete('clients')
      else

        if !::File.directory?('keys')
          ::FileUtils.mkdir('keys')
        end

        ## these are needed to create server and client keys
        ::File.write(::File.join('keys', 'ca.crt'), ca_crt)
        ::File.write(::File.join('keys', 'ca.key'), ca_key)
      end

      return ca_crt
    end

    ## generate cadir and prep to generate keys
    def prep_cadir
      cleanup

      shell_out!("/usr/bin/make-cadir #{cadir}")

      Dir.chdir(cadir)
      ## need to link openssl-*.cnf to openssl.cnf so that build-ca can find it.
      ::File.link('openssl-1.0.0.cnf', 'openssl.cnf')

      shell_out!(". ./vars")
      shell_out!("/bin/sh clean-all")
    end

    ## remove cadir
    def cleanup
      if ::File.directory?(cadir)
        ::FileUtils.rm_rf(cadir)
      end
    end

    def cadir
      @cadir ||= ::File.join(Chef::Config[:file_cache_path], 'openvpn')
    end
  end
end


class Chef::Recipe
  include OpenvpnConfig
end
