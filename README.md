![downloads](https://img.shields.io/github/downloads/mainsail-crew/MainsailOS/total)
[![discord](https://img.shields.io/discord/758059413700345988?color=%235865F2&label=discord&logo=discord&logoColor=white&style=flat)](https://discord.gg/skWTwTD)

# MainsailOS Slipway - Test your Image without Bare Metal

![Mainsail Logo](https://github.com/meteyou/mainsail/raw/master/docs/assets/img/logo.png?raw=true)

A [Raspberry Pi OS](https://www.raspberrypi.org/software/) based distribution for 3d Printers. It includes everything to get started with Klipper Firmware and Mainsail.

## This Repository provides an easy way to test Software.

---

## Requirements

-   [Docker](https://docs.docker.com/engine/install/ubuntu/)
-   [Docker-Compose](https://docs.docker.com/compose/install/)
-   About 6GB of free diskspace for the Image

## Test on an Image of MainsailOS

```bash
git clone https://github.com/mainsail-crew/MainsailOS-slipway.git
cd MainsailOS-slipway/
make run
```

---

## Build layout

MainsailOS-slipway/emulation - Contains dependencies for emulation testing\
MainsailOS-slipway/src/image - Put your Image file here

---

## Ports

To not interfere with local ports I decided to choose different then standard

Mainsail listen on port 8080\
SSH Daemon on Port 2222\
unfortunatly moonraker has to stay at its default port 7125.
