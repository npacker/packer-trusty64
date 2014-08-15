$cwd = "/home/vagrant"

Exec {
  cwd  => "${cwd}",
  path => [
    "/usr/local/bin",
    "/usr/local/sbin",
    "/usr/bin",
    "/usr/sbin",
    "/bin",
    "/sbin"
  ]
}

exec { "cleanup":
  command     => "rm -f failsafe.conf grub",
  refreshonly => true,
  subscribe   => [
    File["failsafe.conf"],
    File["grub"]
  ]
}

exec { "update-grub":
  refreshonly => true,
  subscribe   => File["grub"]
}

include guest_additions

ssh_authorized_key { "vagrant insecure public key":
  key     => "AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==",
  ensure  => present,
  type    => ssh-rsa,
  user    => "vagrant"
}

file { "vagrant":
  path    => "/etc/sudoers.d/vagrant",
  content => "vagrant ALL=(ALL) NOPASSWD: ALL",
  owner   => "root",
  group   => "root",
  mode    => "0644"
}

file { "failsafe.conf":
  path    => "/etc/init/failsafe.conf",
  source  => "file://${cwd}/failsafe.conf",
  owner   => "root",
  group   => "root",
  mode    => "0644"
}

file { "grub":
  path    => "/etc/default/grub",
  source  => "file://${cwd}/grub",
  owner   => "root",
  group   => "root",
  mode    => "0644"
}
