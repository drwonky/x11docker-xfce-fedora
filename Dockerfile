FROM fedora:35

ARG PROXY
RUN dnf makecache && dnf update --setopt=proxy=${PROXY} -y

#RUN dnf --setopt=proxy=${PROXY} groupinstall "Xfce" -y && \
RUN dnf install --setopt=proxy=${PROXY} -y \
      pulseaudio-libs \
      pipewire-pulseaudio \
      mousepad \
      libXv \
      glx-utils \
      mesa-filesystem \
      mesa-libgbm \
      mesa-libglapi \
      mesa-libEGL \
      mesa-libGL \
      mesa-dri-drivers \
      egl-utils \
      psmisc \
      xdg-utils \
      xset \
      xmodmap \
      xhost \
      xrandr \
      xgamma \
      xrdb \
      xsetroot \
      xdpyinfo \
      gtk3 \
      gtk2 \
      xfwm4 \
      xfdesktop \
      xfce4-notifyd \
      xfce4-pulseaudio-plugin \
      xfce4-taskmanager \
      xfce4-terminal \
      xfce4-session \
      xfce4-settings \
      xfce4-screenshooter \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-places-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin 

RUN dnf install --setopt=proxy=${PROXY} -y \
      systemd \
      systemd-libs \
      NetworkManager \
      network-manager-applet \
      NetworkManager-libnm \
      NetworkManager-fortisslvpn \
      NetworkManager-iodine \
      NetworkManager-openvpn \
      NetworkManager-sstp \
      NetworkManager-strongswan \
      NetworkManager-vpnc \
      NetworkManager-l2tp \
      NetworkManager-libreswan \
      NetworkManager-pptp \
      NetworkManager-ssh \
      NetworkManager-openconnect \
      NetworkManager-openconnect-gnome \
      NetworkManager-ssh-gnome \
      NetworkManager-pptp-gnome \
      NetworkManager-libreswan-gnome \
      NetworkManager-l2tp-gnome \
      NetworkManager-vpnc-gnome \
      NetworkManager-strongswan-gnome \
      NetworkManager-sstp-gnome \
      NetworkManager-openvpn-gnome \
      NetworkManager-iodine-gnome \
      NetworkManager-fortisslvpn-gnome \
      dbus-x11 \
      dbus-common \
      dbus \
      dbus-libs \
      dbus-broker \
      xdg-dbus-proxy \
      dbus-glib \
      dbus-tools \
      dbus-daemon \
      polkit \
      net-tools \ 
      telnet \
      openssh-clients \
      gnome-keyring \
      xfce-polkit && \
    systemctl enable NetworkManager && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

# disable xfwm4 compositing if X extension COMPOSITE is missing and no config file exists
RUN Configfile="~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" && \
echo -e "#! /bin/bash\n\
xdpyinfo | grep -q -i COMPOSITE || {\n\
  echo 'x11docker/xfce: X extension COMPOSITE is missing.\n\
Window manager compositing will not work.\n\
If you run x11docker with option --nxagent,\n\
you might want to add option --composite.' >&2\n\
  [ -e $Configfile ] || {\n\
    mkdir -p $(dirname $Configfile)\n\
    echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<channel name=\"xfwm4\" version=\"1.0\">\n\
\n\
  <property name=\"general\" type=\"empty\">\n\
    <property name=\"use_compositing\" type=\"bool\" value=\"false\"/>\n\
  </property>\n\
</channel>\n\
' > $Configfile\n\
  }\n\
}\n\
startxfce4\n\
" > /usr/local/bin/start && \
chmod +x /usr/local/bin/start

CMD start
