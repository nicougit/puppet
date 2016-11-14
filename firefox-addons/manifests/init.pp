class firefox {
	package { firefox:
		ensure => installed,
		allowcdrom => true,
	}

	file { '/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon-229918-latest.xpi':
		content => template('firefox/addon-229918-latest.xpi'),
	}

	file { '/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon-607454-latest.xpi':
		content => template('firefox/addon-607454-latest.xpi'),
	}
}
