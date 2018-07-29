include_attribute "kagent"
include_attribute "elasticsearch"

default['elastic']['version']               = "6.2.3"
default['elastic']['install_type']          = "tarball"
default['elastic']['checksum']              = "01dd8dec5f0acf04336721e404bf4d075675a3acae9f2a9fdcdbb5ca11baca76"
default['elastic']['url']                   = node['download_url'] + "/elasticsearch-#{node['elastic']['version']}.tar.gz"
default['elastic']['user']                  = node['install']['user'].empty? ? "elastic" : node['install']['user']
default['elastic']['group']                 = node['install']['user'].empty? ? "elastic" : node['install']['user']

default['elastic']['port']                  = "9200"

default['elastic']['cluster_name']          = "hops"
default['elastic']['node_name']             = "hopsworks"

default['elastic']['dir']                   = node['install']['dir'].empty? ? "/usr/local" : node['install']['dir']
default['elastic']['version_dir']           = "#{node['elastic']['dir']}/elasticsearch-#{node['elastic']['version']}"
default['elastic']['home_dir']              = "#{node['elastic']['dir']}/elasticsearch"
default['elastic']['plugins_dir']           = node['elastic']['home_dir'] + "/plugins"

default['elastic']['limits']['nofile']      = "65536"
default['elastic']['limits_nproc']          = '65536'

default['elastic']['default_kibana_index']  = "hopsdefault"

default['elastic']['systemd']               = "true"

default['elastic']['memory']['Xms']         = "512m"
default['elastic']['memory']['Xmx']         = "512m"

default['elastic']['thread_stack_size']     = "512k"


default['elastic']['pid_file']              = "/tmp/elasticsearch.pid"

# Kernel tuning
default['elastic']['kernel']['vm.max_map_count']      = "262144"


