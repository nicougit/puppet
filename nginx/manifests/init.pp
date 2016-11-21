class nginx {

	# Katsotaan että Nginx paketti on asennettu
	package { nginx:
		ensure => installed,
		allowcdrom => true,
	}

	# Nginx config
	file { '/etc/nginx/nginx.conf':
		content => template('nginx/nginx.conf'),
		notify => Service['nginx'],
	}

	# Nginx default sivun config
	file { '/etc/nginx/sites-available/default':
		content => template('nginx/default'),
		notify => Service['nginx'],		
	}

	# Katsotaan että Nginx service on päällä
	service { nginx:
		ensure => running, #Katotaan etta on paalla
		enable => true, # Autostartti koneen kaynnistyessa, vaaditaan esim redhatissa
		provider => "systemd",	#Providerin muutto oikeaksi
	}
}

