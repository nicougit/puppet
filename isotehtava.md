## Setting up Nginx, Tomcat 8, MariaDB stack

### Get updates and necessary programs
`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y screen git puppet && screen`

### Clone puppet modules from git repository
`git clone https://github.com/nicougit/puppet.git && cd puppet`

### Copy modules and manifest to /etc/puppet/
`sudo cp nginx tomcat8 mariadb /etc/puppet/modules/ && sudo cp site.pp /etc/puppet/manifests/`

### Run manifest once
`sudo puppet apply -v /etc/puppet/manifests/site.pp`

That's it!
