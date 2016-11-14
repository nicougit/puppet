# Tehtävä 3

## Tehtävänanto

> h3. Tee tavallisia työpöydän asetuksia puppet moduleiksi. Laita ne versionhallintaan. Konfiguroi tyhjä kone, vaikkapa juuri bootattu live-USB, lataamalla puppet-asetukset versionhallinnasta.

## Moduulit

Tein yksinkertaisen package-moduulin joka varmistaa, että Tmux on asennettuna. Mieleeni ei tullut juurikaan mitään käyttämieni softien custom konfiguraatioita, joita olisin voinut hyödyntää tässä tehtävässä.

Yritin tehdä myös moduulia, joka asentaisi Firefoxiin uBlock Origin ja HTTPS Everywhere-addonit. Addonien asennuksen kanssa tuli kuitenkin ongelmia, joita pitää troubleshootata myöhemmin.

### Moduulit gittiin

Olen alusta asti pitänyt Puppet-moduulejani gitissä. Navigoidaan Puppet-hakemistooni, ja varmistetaan että koneeni local repository on ajan tasalla:

`cd puppet && git pull`
`Already up-to-date.`

Lisätään uusin moduuli stagelle, commitataan, ja pushataan githubiin:

`git add tmux/`
`git commit`
`git push`

## Asennus virtuaalikoneella

Ensin näppiksen layout oikeaksi:

`setxkbmap fi`

Asennetaan git ja Puppet, sekä kloonataan oma Puppet-moduulit sisältävä repository Githubista:

`sudo apt-get update && sudo apt-get install -y git puppet && git clone https://github.com/nicougit/puppet.git`

Siirretään uusi Tmux-moduuli oikeaan paikkaan:

`cd puppet && sudo mv tmux/ /etc/puppet/modules/`

Voitaisiin tehdä tiedostoon `etc/puppet/manifests/site.pp` määritys, joka ajaisi kaikki halutut moduulit kerralla, mutta ajetaan nyt manuaalisesti kun moduuleja on vain yksi:

`sudo puppet apply -e 'class {tmux:}'

Tmux asentui ja lähti normaalisti käyntiin komennolla `tmux`.
