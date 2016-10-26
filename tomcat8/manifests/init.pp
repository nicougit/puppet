class tomcat8 {
	package { 'tomcat8':
		ensure		=> installed,
	}

	file { '/var/lib/tomcat8/conf/server.xml':
		content		=> template('tomcat8/server.xml'),
		notify		=> Service['tomcat8'],
	}

	service { 'tomcat8':
		ensure		=> running,
		enable		=> true,
		provider	=> 'systemd',
	}
}
