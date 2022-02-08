![downloads](https://img.shields.io/github/downloads/mainsail-crew/MainsailOS/total)
[![discord](https://img.shields.io/discord/758059413700345988?color=%235865F2&label=discord&logo=discord&logoColor=white&style=flat)](https://discord.gg/skWTwTD)

# MainsailOS Unit Test

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
git clone https://github.com/mainsail-crew/MainsailOS-unittest.git
cd MainsailOS-unittest/
make run
```

---

## Build layout

MainsailOS-unittest/emulation - Contains dependencies for emulation testing
MainsailOS-unittest/src/image - Put your Image here

---
