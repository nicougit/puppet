# SSH konffaus

class sshd {

	package { 'ssh':
		ensure => installed,
		allowcdrom => true,
	}

	file { '/etc/ssh/sshd_config':
		content => template('sshd/sshd_config'),
		notify => Service['sshd'],
	}

	service { 'sshd':
		ensure => running,
		enable => true,
		provider => 'systemd',
	}

}
