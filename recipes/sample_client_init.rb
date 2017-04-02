execute "pkg_update" do
  command node['openvpn']['pkg_update_command']
  action :run
end

package node['openvpn']['pkg_names'] do
  action :upgrade
  notifies :stop, "service[openvpn]", :immediately
end

openvpn_config_client 'sample_client' do
  config node['openvpn']['sample_client']['config']
  action :create
  notifies :restart, "service[openvpn]", :delayed
end

openvpn_credentials 'client_auth' do
  data_bag node['openvpn']['sample_client']['auth-user-pass']['data_bag']
  data_bag_item node['openvpn']['sample_client']['auth-user-pass']['data_bag_item']
  key node['openvpn']['sample_client']['auth-user-pass']['key']
  action :create
  notifies :restart, "service[openvpn]", :delayed
end

openvpn_credentials 'ca.crt' do
  data_bag node['openvpn']['sample_client']['ca']['data_bag']
  data_bag_item node['openvpn']['sample_client']['ca']['data_bag_item']
  key node['openvpn']['sample_client']['ca']['key']
  action :create
  notifies :restart, "service[openvpn]", :delayed
end

include_recipe "openvpn::client_init_service"
