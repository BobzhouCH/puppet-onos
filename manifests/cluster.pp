class onos::cluster ($controllers_ip) {

## create onos cluster
if size($controllers_ip) > 1 and !$onos_cluster_file_path {
  $ip1 = $controllers_ip[0]
  $ip2 = $controllers_ip[1]
  $ip3 = $controllers_ip[2]
  exec{ 'create onos cluster':
        command => "/opt/onos/bin/onos-form-cluster $ip1 $ip2 $ip3"
  }->
  exec{ 'sleep 150 for onos restart':
        command => 'sudo sleep 150;'
  }
}
}