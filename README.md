# Project Ownfoil

Exponer los puertos:
    
    80 -> http (obligatorio abierto para **Caddy** auto SSL)
    443 -> https

first you need the qt package on your raspbery:

```bash
sudo apt install jq
sudo apt install cron # optional in raspbery already installed
```

## ⏰ Automatizar each 5minutes

Agrega este `./script.sh` a crontab:

```bash
crontab -e
```

Y pon:

```
*/5 * * * * /ruta/a/tu/script.sh
```

> Tu subdominio foil.nintendomagica.com siempre apuntará a tu IP pública, y se actualizará automáticamente cada 5 minutos.



