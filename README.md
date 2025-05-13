# Project Ownfoil

Exponer los puertos:
    
    80 -> http (obligatorio abierto para **Caddy** auto SSL)
    443 -> https

first you need the qt package on your raspbery:

```bash
sudo apt install jq
sudo apt install cron # optional in raspbery already installed
```

## ⏰ Automatizar actualizar IP local inhose server 

(porque SiteGround no tiene servidor dns dinamico)

Agrega este `./script.sh` a crontab:

```bash
crontab -e
```

Y pon:

```
*/5 * * * * /ruta/a/tu/script.sh
```

> Tu subdominio foil.nintendomagica.com siempre apuntará a tu IP pública, y se actualizará automáticamente cada 5 minutos.



## Iniciar ownfoil

```bash
docker-compose up -d
```

## Comando para ver el o los servicios

```bash
sudo docker compose ps
```

## Comando para dentener el servicio

```bash
sudo docker compose stop
```

## Comando para iniciar el servicio

```bash
sudo docker compose start
```

## Extra re build contenedor:

Si agregaste cosas al docker-compose.yml puedes usar esto:

```bash
docker compose down # elimina contenedores antiguos
docker compose up -d # reconstruir contenedores
```

### todo on local and pro

- [x] Ejecutar script en servidor
- [x] Configurar en cron el script.sh
- [x] Iniciar docker compose
    `docker-compose up -d`
- [ ] Configurar Proxy reverso con **[Caddy](https://caddyserver.com/)** Easy
    - [ ] Exponer puertos: `80` & `443` en ISP o router
    - [ ] Testear estas condigs
- [ ] Test prueba: acceder desde: `https://foil.nintendomagica.com`


## ✍️ Autor

Proyecto creado por Aníbal Copitán
🔗📝 Blog: https://blog.anibalcopitan.com

