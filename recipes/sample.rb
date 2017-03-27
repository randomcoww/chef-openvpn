execute "pkg_update" do
  command node['openvpn']['pkg_update_command']
  action :run
end

package node['openvpn']['pkg_names'] do
  action :upgrade
  notifies :stop, "service[openvpn@server]", :immediately
end

openvpn_config_server 'openvpn_server' do
  config node['openvpn']['sample']['config']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_ca_crt 'ca.crt' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_dh 'dh' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create_if_missing
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_server_crt 'server.crt' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_server_key 'server.key' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_client_key 'client.key' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

openvpn_easy_rsa_client_crt 'client.crt' do
  data_bag node['openvpn']['sample']['data_bag']
  data_bag_item node['openvpn']['sample']['data_bag_item']
  key node['openvpn']['sample']['label']
  cert_variables node['openvpn']['sample']['cert_variables']
  action :create
  notifies :restart, "service[openvpn@server]", :delayed
end

include_recipe "openvpn::server_service"
