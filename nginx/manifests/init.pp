class nginx {

	package { "nginx":
		ensure		=> installed,
	}

	file { "/etc/nginx/nginx.conf":
		content		=> template("nginx/nginx.conf"),
		notify		=> Service["nginx"],
		require		=> Package["nginx"],
	}

	file { "/etc/nginx/sites-available/default":
		content		=> template("nginx/default"),
		notify		=> Service["nginx"],		
		require		=> Package["nginx"],
	}

	service { "nginx":
		ensure		=> running,
		enable		=> true,
		provider	=> "systemd",
		require		=> Package["nginx"],
	}
}

