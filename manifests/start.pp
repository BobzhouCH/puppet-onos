class onos::start($onos_ip){

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
neutron_plugin_ml2 {
  'ml2_onos/password':           value => 'admin';
  'ml2_onos/username':           value => 'admin';
  'ml2_onos/url_path':           value => "http://$onos_ip:8181/onos/vtn";
}

exec{ 'Configure Neutron3':
        command  => "mysql -e 'drop database if exists neutron;';
                    mysql -e 'create database neutron character set utf8;';
                    mysql -e \"grant all on neutron.* to 'neutron'@'%';\";
                    neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head;",
} ->

        exec{ 'restart neutron':
        command  => "service neutron-server restart",
}

}

