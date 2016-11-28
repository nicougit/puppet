# Tehtävä 5

## Tehtävänanto
> h5. PXE & Preseed. Asenna käsin koskematta käyttöjärjestelmä tyhjään koneeseen verkon yli.

## Valmistelut
Tein tehtävän samassa labraluokassa, jossa kurssin lähiopetus tapahtuu.

Asensin ensin palvelinkoneelle tarvittavat ohjelmat:
* `arpwatch` asennettavan koneen fyysisen osoitteen selvittämiseksi
* `wakeonlan` wake on lan-pyynnön lähettämiseksi
* `isc-dhcp-server` dhcp palvelimeksi
* `tftp-hpa` ja `tftpd-hpa` tftp-palvelimeksi asennustiedostojen siirtoon

Sen jälkeen boottasin asennettavan koneen ja nähdäkseni sen fyysisen osoitteen. Sen jälkeen tarkistin fyysisen osoitteen myös palvelinkoneeni syslogista, johon `arpwatch` oli sen kirjannut. Seuraavaksi conffasin DHCP-palvelimen, jotta pystyin antamaan kohdekoneelle haluamani IP-osoitteen ja muut tiedot. Kohdekoneen fyysinen osoite oli `78:ac:c0:ba:76:26`.

## DHCP:n conffaus

#### /etc/dhcp/dhcpd.conf:
```
ddns-update-style none;

default-lease-time 600;
max-lease-time 7200;

authoritative;

# Muista nämä!
next-server 172.28.172.69;
filename "pxelinux.0";

log-facility local7;

subnet 172.28.0.0 netmask 255.255.0.0 {
                host nicontesti {
                hardware ethernet 78:ac:c0:ba:76:26;
                option domain-name-servers 4.4.4.4, 8.8.8.8;
                option domain-name "tielab.haaga-helia.fi";
                option subnet-mask 255.255.0.0;
                fixed-address 172.28.1.243;
                option routers 172.28.1.254;
                default-lease-time 600;
                max-lease-time 7200;
        }
}
```

Lisäsin myös käytettävän verkkokortin interfacen configgiin (`/etc/dhcp/dhcpd.conf`) viimeiselle riville: `INTERFACES="eno1"`

Konfiguraation muokkauksen jälkeen otetaan muutokset käyttöön käynnistämällä DHCP-palvelin uudelleen: `sudo service isc-dhcp-server restart`.

Tässä vaiheessa on hyvä testata, että kohdekone saadaan käynnistettyä etänä, ja että se saa IP-osoitteen halutulta DHCP-palvelimelta:

`wakeonlan 78:ac:c0:ba:76:26`

Komennon suoritettua näin, että kohdekone käynnistyi ja sai määrittämäni IP-osoitteen `172.28.1.243`.

## Asennuspaketit

Ladataan Ubuntu 16.04 Xenial netboot-paketti, puretaan se, ja siirretään `/var/lib/tftpboot/` hakemistoon.

#### syslinux.cfg Tero Karvisen [mallista](http://terokarvinen.com/2016/aikataulu-palvelinten-hallinta-ict4tn022-1-5-op-uusi-ops-loppusyksy-2016#comment-22004)
```
# D-I config version 2.0
# search path for the c32 support libraries (libcom32, libutil etc.)
path ubuntu-installer/amd64/boot-screens/
include ubuntu-installer/amd64/boot-screens/menu.cfg
default ubuntu-installer/amd64/boot-screens/vesamenu.c32

label nicoupxe
        kernel ubuntu-installer/amd64/linux
        append initrd=ubuntu-installer/amd64/initrd.gz auto=true auto url=tftp://172.28.172.69/ubuntu-installer/amd64/preseed.cfg locale=en_US.UTF-8 classes=minion DEBCONF_DEBUG=5 priority=critical preseed/url/=ubuntu-installer/amd64/preseed.cfg netcfg/choose_interface=auto

prompt 0
timeout 0
default nicoupxe
```

Seuraavaksi preseedin määritys:

#### Joona Leppälahden [preseed.cfg](https://joonaleppalahti.wordpress.com/2016/11/18/palvelinten-hallinta-harjoitus-8/) muokattuna
```
d-i passwd/user-fullname string Nico Hagelberg
d-i passwd/username string nicou
d-i passwd/user-password password salasana
d-i passwd/user-password-again password salasana

d-i partman-auto/method string regular

d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true

d-i partman-auto/choose_recipe select atomic

d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i pkgsel/include string puppet ssh

d-i pkgsel/update-policy select none

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

d-i finish-install/reboot_in_progress note
```

## Asennus
Sammutin kohdekoneen ja lähetin sille jälleen palvelinkoneelta käynnistyspyynnön wakeonlanilla. Kone käynnistyi ja lähti asentamaan Ubuntua kuten pitikin. Asennuksen päätteksi sain otettua asennetulle koneelle SSH-yhteyden. Pitää yrittää myöhemmin tehdä sama uudelleen käyttäen post-install scriptiä, jolla saisi koneen suoraan Puppet-orjaksi.
