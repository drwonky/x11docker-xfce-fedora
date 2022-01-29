# x11docker/xfce

XFCE desktop in Docker image. Based on Fedora.
 - Run XFCE desktop in docker.
 - Use [x11docker](https://github.com/mviereck/x11docker) to run GUI applications and desktop environments in docker images. 

# Building
This is the command I use to build the image, it takes advantage of a caching proxy server:

`docker build --build-arg PROXY=http://my-proxy.local:3128/ -t x11docker/xfce-fedora .`

If you don't have a proxy, don't add the build arg, docker should default to an empty value and dnf will default to no proxy.

# NetworkManager
A custom version of x11docker is included in this repo which enables NetworkManager.service when using systemd.  By default
NetworkManager is not enabled and this breaks the network-manager-applet because NetworkManager is not running.

# Command examples: 
 - Run a full desktop: `./x11docker --network --init=systemd --desktop --clipboard --pulseaudio=tcp --home=/path/to/persistent/home x11docker/xfce-fedora`
 - Single application: `x11docker x11docker/xfce-fedora thunar`

# Options:
 - Persistent home folder stored on host with   `--home`
 - Shared host file or folder with              `--share PATH`
 - Hardware acceleration with option            `--gpu`
 - Clipboard sharing with option                `--clipboard`
 - ALSA sound support with option               `--alsa`
 - Pulseaudio sound support with option         `--pulseaudio`
 - Language locale settings with                `--lang [=$LANG]`
 - Printing over CUPS with                      `--printer`
 - Webcam support with                          `--webcam`

Look at `x11docker --help` for further options.

# Extend base image
To add your desired applications, create your own Dockerfile with this image as a base. Example:
```
FROM x11docker/xfce-fedora
RUN dnf update -y
RUN dnf install -y midori
```
 # Screenshot
 XFCE desktop in an Xnest window running with x11docker:
 
 ![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-xfce.png "XFCE desktop running in Xephyr window using x11docker")
 

