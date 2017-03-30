# comment neutron and dhcp related steps
#
#
#
#

class onos::start($onos_ip){

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
neutron_plugin_ml2 {
  'onos/password':           value => 'admin';
  'onos/username':           value => 'admin';
  'onos/url_path':           value => "http://$onos_ip:8181/onos/vtn";
}

# in openstack newton. dhcp agent use native(ovsdb) as default. We need vsctl.

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
neutron_dhcp_agent_config {
    'OVS/ovsdb_interface':   value => 'vsctl';
}

include ::neutron::deps
}

