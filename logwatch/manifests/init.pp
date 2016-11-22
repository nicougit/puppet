# Originally from https://usgcb.nist.gov/usgcb/rhel/download_rhel5.html

class logwatch {
	package { "logwatch":
		ensure => installed,
	}

	exec { "/bin/rm /etc/cron.daily/00logwatch":
		onlyif => "/usr/bin/test -e /etc/cron.daily/00logwatch",
		user   => "root";
	}
}
