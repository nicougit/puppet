# Puppet module for installing and configuring Tomcat 8, Nginx and MariaDB stack
# and deploying Passi web application to Tomcat.

class passi {

	# MariaDB
	package { "mariadb-server-10.0":
		ensure => installed,
	}

	service { "mysql":
		enable => true,
		ensure => running,
		provider => "systemd",
		require => Package["mariadb-server-10.0"],
	}

	# Nginx
	package { "nginx":
		ensure => installed,
	}

	file { "/etc/nginx/nginx.conf":
		content => template("passi/nginx.conf"),
		notify => Service["nginx"],
		require => Package["nginx"],
	}

	file { "/etc/nginx/sites-available/default":
		content => template("passi/default"),
		notify => Service["nginx"],
		require => Package["nginx"],
	}

	service { "nginx":
		ensure => running,
		enable => true,
		provider => "systemd",
		require => Package["nginx"],
	}

	# Tomcat 8
	package { "tomcat8":
		ensure => installed,
	}

	file { "/var/lib/tomcat8/conf/server.xml":
		content => template("passi/server.xml"),
		notify => Service["tomcat8"],
		require => Package["tomcat8"],
	}

	service { "tomcat8":
		ensure => running,
		enable => true,
		provider => "systemd",
	}

	# Deploying Passi web application
	file { "/var/lib/tomcat8/webapps/passi.war":
		ensure => "present",
		source => "puppet:///modules/passi/passi.war",
		require => Service["tomcat8"],
	}

	# Deploying Passi REST application
	file { "/var/lib/tomcat8/webapps/passi-rest.war":
		ensure => "present",
		source => "puppet:///modules/passi/passi-rest.war",
		require => Service["tomcat8"],
	}

	# Make sure that MySQL user and database schema exist
	file { "/etc/puppet/modules/passi/files/passi_schema.sql":
		ensure => "present",
	}

	exec { "setup-passi-db":
		unless => "mysql -u$mysql_user -p$mysql_password $db_name",
		path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
		command => "mysql -Bse \"CREATE DATABASE $db_name;\" && mysql -Bse \"CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password';\" && mysql -Bse \"GRANT ALL PRIVILEGES ON $db_name.* TO '$mysql_user'@'localhost';\" && mysql $db_name < /etc/puppet/modules/passi/files/passi_schema.sql",
		require => [ Service["mysql"], File["/etc/puppet/modules/passi/files/passi_schema.sql"] ],
	}
}
