# Puppet module for installing Tomcat 8, Nginx and MariaDB stack
# and downloading and deploying a demo webapp "Alkotool"

class alkotool {

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
	package { nginx:
		ensure => installed,
		allowcdrom => true,
	}

	file { '/etc/nginx/nginx.conf':
		content => template('alkotool/nginx.conf'),
		notify => Service['nginx'],
		require => Package['nginx'],
	}

	file { '/etc/nginx/sites-available/default':
		content => template('alkotool/default'),
		notify => Service['nginx'],		
		require => Package['nginx'],
	}

	service { nginx:
		ensure => running,
		enable => true,
		provider => "systemd",
		require => Package['nginx'],
	}

	# Tomcat 8
	package { 'tomcat8':
		ensure		=> installed,
	}

	file { '/var/lib/tomcat8/conf/server.xml':
		content		=> template('alkotool/server.xml'),
		notify		=> Service['tomcat8'],
		require		=> Package['tomcat8'],
	}

	service { 'tomcat8':
		ensure		=> running,
		enable		=> true,
		provider	=> 'systemd',
	}

	# Download and deploy Alkotool .war to Tomcat
	exec { 'alkodeploy':
		path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
		command => "wget https://nicou.me/alkotool.war -P /var/lib/tomcat8/webapps/",
		creates => "/var/lib/tomcat8/webapps/alkotool.war",
		require => Service['tomcat8'],
	}

	# Download and deploy Alkotool database to MariaDB
	exec { 'alkodbdeploy':
		path => "/bin/:/usr/bin/:/sbin/:/usr/sbin/",
		command => "mysql -e \"CREATE DATABASE juomakanta;\" && mysql -Bse \"CREATE USER 'alkotool'@'localhost' IDENTIFIED BY 'AwDvklPURO2k7Ql';\" && mysql -Bse \"GRANT ALL PRIVILEGES ON juomakanta.* TO 'alkotool'@'localhost';\" && wget https://nicou.me/alkodb.sql -P /tmp/ && mysql juomakanta < /tmp/alkodb.sql && rm /tmp/alkodb.sql", 
		unless => "mysqlshow juomakanta",
		require => Service["mysql"],
	}
}
