class onos::service () {

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 360,
        logoutput => 'true',
}
firewall {'215 onos':
      port   => [ 6633, 6640, 6653, 8181, 8101,9876],
      proto  => 'tcp',
      action => 'accept',
}->
exec{ 'start onos':
        command => 'service onos start',
        unless => 'service onos status | grep PID'
}->

#service{ 'onos':
#        ensure => running,
#        enable => true,
#}->
exec{ 'sleep 150 to stablize onos':
        command => 'sudo sleep 150;'
}->

exec{ 'install openflow feature':
        command => "/opt/onos/bin/onos 'feature:install onos-providers-openflow-message'"
}->
exec{ 'install optical feature':
        command => "/opt/onos/bin/onos 'feature:install onos-optical-model'"
}->
exec{ 'install openflow-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-providers-openflow-base'"
}->
exec{ 'install onos-ovsdb-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-providers-ovsdb-base'"
}->
exec{ 'install onos-ovsdb-provider-host feature':
        command => "/opt/onos/bin/onos 'feature:install onos-providers-ovsdb-host'"
}->
exec{ 'install onos-drivers-ovsdb feature':
        command => "/opt/onos/bin/onos 'feature:install onos-drivers-ovsdb'"
}->
exec{ 'sleep 30 to stablize onos features':
        command => 'sudo sleep 30;'
}->
exec{ 'install vtn feature':
        command => "/opt/onos/bin/onos 'feature:install onos-apps-vtn'"
}->
exec{ 'add onos auto start':
        command => 'sudo echo "onos">>/opt/service',
        logoutput => "true",
}-> 
exec{ 'set public port':
        command => "/opt/onos/bin/onos 'externalportname-set -n onos_port2'",
}

}
