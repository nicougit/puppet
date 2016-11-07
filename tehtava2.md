#Tehtävä 2

Tehtävänanto: http://terokarvinen.com/2016/aikataulu-linuxin-keskitetty-hallinta-ict4tn011-10-loppusyksy-2016
> h2. Säädä orjia verkon yli puppetmasterin avulla (master-slave pull arkkitehtuuri. Jos et pääse käyttämään kahta konetta, voit asentaa herran ja orjan samalle koneelle)

## Koneet
Päätin laittaa Puppetmasterin pyörimään Raspberry Pi:lle (käyttöjärjestelmänä Raspbian Wheezy) ja määrittää sille orjaksi läppärini, jossa pyöri livetikulla Xubuntu 16.04.

## Herran säätö
Asensin ensin puppetin ja puppetmasterin:
```
sudo apt-get update && sudo apt-get install -y puppet puppetmaster
```
Koska hostname oli jo säädetty kuntoon Raspberry Pi:llä, niin ei tarvinnut tehdä samoja säätöjä SSL-certtien kanssa kuin mitä tuntiharjoituksissa.

Kloonasin herralle githubista aiemmin tekemäni Nginx moduulin ja siirsin sen oikeaan hakemistoon (`/etc/puppet/modules/nginx`). Moduuli on file, packet, service-moduuli, joka asentaa ja konfiguroi Nginx-webbipalvelimen. Se muuttaa myös oletuksena näkyvän index-tiedoston tiedostoksi, johon tulostetaan muuttujalla päivä ja kellonaika jolloin tiedosto on haettu puppetmasterilta.

Moduulin määrityksen jälkeen loin tiedoston `/etc/puppet/manifests/site.pp`, jossa määritetään orjien käyttämät moduulit. Lisäsin sinne sisällön, joka määrittää, että orjille jaellaan Nginx-moduuli:
```
include nginx
```

Tämän jälkeen käynnistin puppetmaster-servicen uudelleen (olisikohan tarvinnut?):
```
sudo service puppetmaster restart
```

## Slaven säätö
Puppetin asennus:
```
sudo apt-get update && sudo apt-get install -y puppet
```

Asennuksen jälkeen määritetään herran hostname Puppetin konfiguraatioihin (`/etc/puppet/puppet.conf`):
```
[agent]
server = raspberrypi.home
```

Käynnistetään Puppet uudelleen:
```
sudo service puppet restart
```
Enabloidaan orja (agent) ja otetaan yhteys herraan:
```
sudo puppet agent --enable
sudo puppet agent --test -d
```
## Sertifikaatin allekirjoitus herralla
Katsotaan lista sertifikaateista:
```
nicou@raspberrypi ~ $ sudo puppet cert list --all
  "xubuntu.home"       (3A:84:8F:AE:AA:43:10:89:53:36:C4:D6:C4:C1:B3:07)
+ "raspberrypi.home"   (E2:5C:F5:43:91:D9:F1:3C:EA:C3:3F:1C:BA:68:3D:1B)
```

Allekirjoitetaan orjan sertifikaatti:
```
nicou@raspberrypi ~ $ sudo puppet cert sign xubuntu.home
notice: Signed certificate request for xubuntu.home
notice: Removing file Puppet::SSL::CertificateRequest xubuntu.home at '/var/lib/puppet/ssl/ca/requests/xubuntu.home.pem'

```

## Viimeistely orjalla
Ajetaan agentin testi uudelleen:
```
sudo puppet agent --test -d
```
Komennon suorituksessa kestää hetki. Kun komento menee onnistuneesti läpi, on Nginx nyt asennettu ja konfiguroitu! `http://xubuntu.home/` -osoitteessa on nyt herran Nginx-templatessa määritetty index-tiedosto.
