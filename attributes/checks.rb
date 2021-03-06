warn_load_threshold = node['cpu']['total'] * 2
crit_load_threshold = node['cpu']['total'] * 3

default['monitoring']['cpu']['disabled']         = false
default['monitoring']['cpu']['alarm']            = false
default['monitoring']['cpu']['period']           = 90
default['monitoring']['cpu']['crit']             = 95
default['monitoring']['cpu']['warn']             = 90

default['monitoring']['disk']['disabled']        = false
default['monitoring']['disk']['alarm']           = false
default['monitoring']['disk']['target']          = '/dev/xvda1'
default['monitoring']['disk']['target_mountpoint'] = '/'
default['monitoring']['disk']['alarm_criteria']  = ''

default['monitoring']['filesystem']['disabled']  = false
default['monitoring']['filesystem']['alarm']     = false
default['monitoring']['filesystem']['crit']      = 90
default['monitoring']['filesystem']['warn']      = 80
default['monitoring']['filesystem']['non_monitored_fstypes'] = %w(tmpfs devtmpfs devpts proc mqueue cgroup efivars sysfs sys securityfs configfs fusectl)

# during chefspec tests with fauxhai, node['filesystem'] might be nil
unless node['filesystem'].nil?
  node['filesystem'].each do |key, data|
    next if data['percent_used'].nil? || data['fs_type'].nil?
    next if node['monitoring']['filesystem']['non_monitored_fstypes'].nil?
    next if node['monitoring']['filesystem']['non_monitored_fstypes'].include?(data['fs_type'])
    default['monitoring']['filesystem']['target'][key] = data['mount']
  end
end

default['monitoring']['load_average']['disabled'] = false
default['monitoring']['load_average']['alarm']   = false
default['monitoring']['load_average']['crit']    = crit_load_threshold
default['monitoring']['load_average']['warn']    = warn_load_threshold

default['monitoring']['memory']['disabled']      = false
default['monitoring']['memory']['alarm']         = false
default['monitoring']['memory']['crit']          = 95
default['monitoring']['memory']['warn']          = 90

default['monitoring']['network']['disabled']     = false
default['monitoring']['network']['alarm']        = false
default['monitoring']['network']['target']       = 'eth0'
default['monitoring']['network']['recv']['crit'] = '76000'
default['monitoring']['network']['recv']['warn'] = '56000'
default['monitoring']['network']['send']['crit'] = '76000'
default['monitoring']['network']['send']['warn'] = '56000'

default['monitoring']['chef-client']['label'] = 'chef-client'
default['monitoring']['chef-client']['disabled'] = true
default['monitoring']['chef-client']['file_url'] = 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
default['monitoring']['chef-client']['alarm']['label'] = ''
default['monitoring']['chef-client']['alarm']['notification_plan_id'] = 'npMANAGED'
default['monitoring']['chef-client']['alarm']['criteria'] = ''

# NOTE: this is for 'service monitoring' using service_mon.sh. go to the next section for arbitrary monitors.
# Currently for service monitoring, the recipe that sets up the service should add:
# node.default['monitoring']['service']['name'].push('<service_name>')
default['monitoring']['service']['name']         = []
default['monitoring']['service']['disabled']     = false
default['monitoring']['service']['alarm']        = false

# Remote-http monitors.
default['monitoring']['remote_http']             = []
