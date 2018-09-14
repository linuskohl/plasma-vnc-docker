FROM phusion/baseimage

MAINTAINER Linus Kohl "linus@munichresearch.com"

ENV LANG en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

CMD ["sbin/my_init"]

# Update
RUN apt-get update

RUN echo $LANG UTF-8 > /etc/locale.gen && \
    apt-get install -y locales && update-locale --reset LANG=$LANG

# Install packages
RUN apt-get install -y dbus dbus-x11 procps psmisc \
                       mesa-utils mesa-utils-extra libxv1 kmod xz-utils \
                       xserver-xorg xserver-xorg-video-dummy xorg xserver-xorg-input-void \
                       at-spi2-core gtk3-engines-breeze \
                       kate kcalc kde-config-screenlocker \
                       kde-style-breeze-qt4 kde-style-qtcurve \
                       kruler libqt5multimedia5-plugins psmisc \
                       qt-at-spi \
                       systemsettings xdg-user-dirs libpam-kwallet5 libkwalletbackend5-5 \
                       wget nano xinetd net-tools \
                       xdg-utils xdg-user-dirs \
                       menu menu-xdg mime-support desktop-file-utils \
                       plasma-desktop plasma-workspace-wayland kwin-wayland kwin-wayland-backend-x11 kwin-wayland-backend-wayland kwin consolekit \
                       lightdm xinit dolphin \
                       chromium-browser && \
                       ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
    
# Install tigervnc 1.9
RUN wget -qO- https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-1.9.0.x86_64.tar.gz | tar xz --strip 1 -C /

COPY etc/xinetd.conf /etc/xinetd.conf
COPY etc/xinetd.d/vncserver /etc/xinetd.d/vncserver
COPY etc/X11/xorg.conf /etc/X11/xorg.conf
COPY etc/X11/default-display-manager /etc/X11/default-display-manager
COPY etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
COPY etc/pulse/client.conf /etc/pulse/client.conf
COPY etc/skel/ /etc/skel
COPY my_init.d /etc/my_init.d

RUN chmod +x /etc/my_init.d/*

RUN echo "vncserver       5900/tcp                    " >> /etc/services
