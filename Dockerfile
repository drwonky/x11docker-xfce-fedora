FROM fedora:35

RUN dnf makecache && dnf update && dnf install -y \
      dbus-x11 \
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
      xorg-x11-utils \
      xfce4 \
      gtk3 \
      gtk2 \
      pulseaudio-libs \
      pipewire-pulseaudio \
      mousepad \
      xfce4-notifyd \
      xfce4-pulseaudio-plugin \
      xfce4-taskmanager \
      xfce4-terminal \
      xfce4-settings \
      xfce4-screenshooter \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
      xfce4-places-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin \
      libXv \
      mesa-utils \
      mesa-utils-extra && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

# disable xfwm4 compositing if X extension COMPOSITE is missing and no config file exists
RUN Configfile="~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" && \
echo "#! /bin/bash\n\
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
