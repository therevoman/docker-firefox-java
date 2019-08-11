# Firefox over VNC
#
# VERSION               0.1
# DOCKER-VERSION        0.2

from    f69m/ubuntu32:14.04

# make sure the package repository is up to date
run     echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run     apt-get update

# Install vnc, xvfb in order to create a 'fake' display and firefox
run     apt-get install -y x11vnc xvfb openbox 

# Install the specific tzdata-java we need
run     apt-get -y install wget && \
        wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/tzdata-java_2016j-0ubuntu0.14.04_all.deb && \
        dpkg -i tzdata-java_2016j-0ubuntu0.14.04_all.deb && \
        apt-get install -y tzdata

# Install Firefox and Java Plugins
run     apt-get install -y firefox icedtea-7-plugin icedtea-netx openjdk-7-jre openjdk-7-jre-headless tzdata-java python-pip && \
        mkdir ~/.vnc && \
        pip install --index-url=https://pypi.python.org/simple/ pyxdg 

# Remove bad alternatives and set the right ones.
run     update-alternatives --remove itweb-settings /usr/lib/jvm/java-6-openjdk-i386/jre/bin/itweb-settings && \
        update-alternatives --remove javaws /usr/lib/jvm/java-6-openjdk-i386/jre/bin/javaws && \
        update-alternatives --auto java
        #update-alternatives --config java /usr/lib/jvm/java-7-openjdk-i386/jre/bin/java

# Autostart firefox (might not be the best way to do it, but it does the trick)
run     bash -c 'echo "exec openbox-session &" >> ~/.xinitrc' && \
        bash -c 'echo "firefox" >> ~/.xinitrc' && \
        bash -c 'chmod 755 ~/.xinitrc' 

