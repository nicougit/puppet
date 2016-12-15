# Passi environment deployment manifest

## What it does
* Makes sure that Tomcat 8 is installed and configured properly (listen to localhost only)
* Makes sure that Nginx is installed and configured properly (proxy specific URLs to Tomcat)
* Makes sure that MariaDB is installed
* Makes sure that Passi web application & Passi REST application are deployed to Tomcat
* Makes sure that the MySQL database and database user required by the Passi applications exists

## Usage
Create directory `/etc/puppet/modules/passi/` and move the `files/`, `manifests/`, and `templates/` directories there. Edit `site.pp` to include `$mysql_user`, `$mysql_password` and `$db_name` and then move `site.pp` to `/etc/puppet/manifests/`. Also move the applications (`passi.war` & `passi-rest.war`) and the SQL dump `passi_schema.sql` to `/etc/puppet/modules/passi/files/`.
