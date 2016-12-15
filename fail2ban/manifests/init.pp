class fail2ban {
	package { "fail2ban":
		ensure		=> installed,
	}

	file { "/etc/fail2ban/jail.d/customjail.local":
		content		=> template("fail2ban/customjail.local"),
		notify		=> Service["fail2ban"],
		require		=> File["fail2ban"],
	}

	file { "/etc/fail2ban/filter.d/nginx-xmlrpc.conf":
		content		=> template("fail2ban/nginx-xmlrpc.conf"),
		notify		=> Service["fail2ban"],
		require		=> Package["fail2ban"],
	}

	service { "fail2ban":
		ensure		=> running,
		enable		=> true,
		provider	=> "systemd",
	}
}
