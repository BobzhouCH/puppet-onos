class onos::install{

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
}

file{ '/root/.m2/':
        ensure => 'directory',
        recurse => true,
} ->
file{ '/root/.m2/repository.tar':
        source => "puppet:///modules/onos/repository.tar",
} ->
exec{ "unzip packages":
        command => "tar xf /root/.m2/repository.tar -C /root/.m2/",
}
}
