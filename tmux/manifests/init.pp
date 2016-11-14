class tmux {
	package { tmux:
		ensure => installed,
		allowcdrom => true,
	}
}
