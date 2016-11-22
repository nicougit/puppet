# Tehtävä 4

## Tehtävänanto
> Sovita oma moduuli jostain valmiista kolmannen osapuolen paketista. Poista kaikki ylimääräinen.

## Moduulin valinta
Tähän soveltuvien pakettien löytämisessä itselläni ainakin oli ongelmia. Lähes kaikki itseäni kiinnostavat valmiit moduulit sisälsivät satojen/tuhansien rivien manifesteja.

Päädyin käyttämään [The United States Government Configuration Baseline](https://usgcb.nist.gov/usgcb/rhel/download_rhel5.html)-paketista löytyvää Logwatch-moduulia, joka poistaa Logwatchin päivittäisen cron-jobin. Lisäsin moduuliin myös Logwatchin paketin asennuksen.

## Moduulin muokkaus

Ladataan ja puretaan US Government Configuration Baseline Puppet-moduulit:

`wget https://usgcb.nist.gov/usgcb/content/configuration/puppet-sdc-dist.tar.gz && tar xfv puppet-sdc-dist.tar.gz`

Muokataan logwatch-moduulin `init.pp`-tiedoston sisältö:
```
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

```

## Moduulin käyttöönotto

Siirretään moduuli paikoilleen:

`sudo mv logwatch /etc/puppet/modules/`

Testauksen vuoksi asennetaan Logwatch ennen moduulin ajamista:

`sudo apt-get update && sudo apt-get -y install logwatch`

Nähdään, että `/etc/cron.daily/`-hakemisto sisältää `00logwatch`-jobin:

```
xubuntu@xubuntu:/etc/cron.daily$ ls
00logwatch  0anacron  apport  apt-compat  bsdmainutils  dpkg  logrotate  man-db  mlocate  passwd  popularity-contest  update-notifier-common  upstart
```

Otetaan moduuli käyttöön:

`sudo puppet apply -e "class {logwatch:}"`

Todetaan, että `00logwatch`-tiedosto on poistunut:

```
xubuntu@xubuntu:/etc/cron.daily$ ls
0anacron  apport  apt-compat  bsdmainutils  dpkg  logrotate  man-db  mlocate  passwd  popularity-contest  update-notifier-common  upstart
```
