class onos::ovs ($controllers_ip){
$neutron_ovs_agent = $::operatingsystem ? {
  'CentOS' => 'neutron-openvswitch-agent',
  'Ubuntu' => 'neutron-plugin-openvswitch-agent',
}

$ovs_service = $::operatingsystem ? {
  'CentOS' => 'openvswitch',
  'Ubuntu' => 'openvswitch-switch',
}

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
}

$cmd_remove_ovs_agent = $operatingsystem ? {
  'CentOS' => 'systemctl disable neutron-openvswitch-agent',
  'Ubuntu' => 'update-rc.d neutron-plugin-openvswitch-agent remove',
}

$cmd_remove_l3_agent = $operatingsystem ? {
  'CentOS' => 'systemctl disable neutron-l3-agent',
  'Ubuntu' => 'update-rc.d neutron-plugin-l3-agent remove',
}

firewall{'216 vxlan':
      port   => [4790],
      proto  => 'udp',
      action => 'accept',
}->

        exec{'remove neutron-plugin-openvswitch-agent auto start':
        command => "touch /opt/service;
                $cmd_remove_ovs_agent;
                sed -i /neutron-openvswitch-agent/d /opt/service",
} ->
        exec{'remove neutron-plugin-l3-agent auto start':
        command => "touch /opt/service;
                $cmd_remove_l3_agent;
                sed -i /neutron-l3-agent/d /opt/service",
} ->   service {"shut down and disable Neutron's agent services":
        name => $neutron_ovs_agent,
        ensure => stopped,
        enable => false,
}->
#
#        exec{'Stop the OpenvSwitch service and clear existing OVSDB':
#        command =>  "service $ovs_service stop ;
#        rm -rf /var/log/openvswitch/* ;
#        rm -rf /etc/openvswitch/conf.db ;
#        service $ovs_service start ;"
#
#}->
     file{ '/opt/set_external_port.sh':
        source => "puppet:///modules/onos/set_external_port.sh",
}->     
     exec{ 'prepare external port':
        command => "sudo sh /opt/set_external_port.sh",
        path => "/usr/bin:/usr/sbin:/bin:/sbin",

}->
     exec{ 'sleep 20 to stablize onos in ovs.pp':
        command => 'sudo sleep 20;'
}

if count($controllers_ip) > 1 {
     exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:$controllers_ip[0]:6640 tcp:$controllers_ip[1]:6640 tcp:$controllers_ip[2]:6640'",
         }
} else {
     exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:$controllers_ip:6640'",
         }
}
     exec{ 'sleep 30 for ovs config stable':
        command => 'sudo sleep 30;'
}->
     exec{'Remove manager on ovs':
        command => "su -s /bin/sh -c 'ovs-vsctl del-manager'",
}->
     exec{'Remove br-int on ovs':
        command => "su -s /bin/sh -c 'ovs-vsctl del-br br-int'",
        onlyif => "su -s /bin/sh -c 'ovs-vsctl br-exists br-int'"
}

if count($controllers_ip) > 1 {
     exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:$controllers_ip[0]:6640 tcp:$controllers_ip[1]:6640 tcp:$controllers_ip[2]:6640'",
         }
} else {
     exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:$controllers_ip:6640'",
         }
}

}
