class onos::cluster ($controllers_ip) {

## create onos cluster
  $ip1 = $controllers_ip[0]
  $ip2 = $controllers_ip[1]
  $ip3 = $controllers_ip[2]
  exec{ 'create onos cluster':
        command => "/opt/onos/bin/onos-form-cluster $ip1 $ip2 $ip3",
		onlyif => "test ! -f $onos_cluster_file_path",
		path => "/usr/bin:/usr/sbin:/bin:/sbin",
		logoutput => "true",
		timeout => 30
  }->
  exec{ 'sleep 150 for onos restart':
        command => 'sudo sleep 150',
		path => "/usr/bin:/usr/sbin:/bin:/sbin",
		onlyif => "test ! -f $onos_cluster_file_path",
		timeout => 150
  }
}