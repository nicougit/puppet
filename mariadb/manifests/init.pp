class mariadb {
	package { "mariadb-server-10.0":
		ensure => installed,
	}

	service { "mysql":
		enable => true,
		ensure => running,
		provider => "systemd",
		require => Package["mariadb-server-10.0"],
	}
}
