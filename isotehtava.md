## Tomcat 8 deployment module

### What it does

This module installs __Tomcat 8__, __Nginx__ and __MariaDB__, ensures that the services are running, and then downloads and deploys a demo web application and its database. While deploying the database it will also generate the database user for the application. Including the SQL user credentials in this module is generally a very bad idea, but this is a demo application and the credentials are not used anywhere else. The module will also configure Tomcat 8 to only listen to localhost, and configure Nginx to proxy requests from http port (80) to Tomcat (port 8080).

Once the module is run, it will take a while (around 20 seconds) for Tomcat to deploy the application. After that it can be accessed via http://localhost/.

#### Get updates and necessary programs (screen is totally necessary)
`sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y screen git puppet && screen`

#### Clone puppet modules from git repository
`git clone https://github.com/nicougit/puppet.git && cd puppet`

#### Copy the module to correct location
`sudo cp -r alkotool /etc/puppet/modules/`

To run the module with a simple `sudo puppet apply /etc/puppet/manifests/site.pp` you can add a `site.pp` file to `/etc/puppet/manifests/` with the content:
```
class {alkotool:}
```

#### Run the manifest
`sudo puppet apply -v /etc/puppet/manifests/site.pp` or if you did not create the `site.pp` file you can do `sudo puppet apply -e 'class {alkotool:}`.

#### Test it out
You should now be able to access the demo application via your browser by navigating to http://localhost/.
