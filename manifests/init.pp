class onos($controllers_ip){

$ovs_manager_ip = $controllers_ip[0]

$onos_home = '/opt/onos'
$onos_pkg_url = 'http://downloads.onosproject.org/release/onos-1.6.0.tar.gz'
$karaf_dist = 'apache-karaf-3.0.5'
$onos_pkg_name = 'onos-1.6.0.tar.gz'
$jdk8_pkg_name = 'jdk-8u51-linux-x64.tar.gz'
$onos_boot_features = 'config,standard,region,package,kar,ssh,management,webconsole,onos-api,onos-core,onos-incubator,onos-cli,onos-rest,onos-gui,onos-openflow-base,onos-openflow'
$onos_extra_features = 'ovsdb,vtn'

class {'::onos::install':}->
class {'::onos::config':}->
class {'::onos::service':
      controllers_ip => $controllers_ip}->
}
