## Setting up Nginx, Tomcat 8, MariaDB stack

### Get updates and necessary programs
`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y screen git puppet && screen`

### Clone puppet modules from git repository
`git clone https://github.com/nicougit/puppet.git
cd puppet`

### Copy modules and manifest to /etc/puppet/
`sudo cp nginx tomcat8 mariadb /etc/puppet/modules/ && sudo cp site.pp /etc/puppet/manifests/`

### Run manifest once to install packages
`sudo puppet apply -v /etc/puppet/manifests/site.pp`

### Run manifest again to finish configuration
`sudo puppet apply -v /etc/puppet/manifests/site.pp`

### Configure MySQL root password and disable anonymous login
`sudo mysql_secure_install`
