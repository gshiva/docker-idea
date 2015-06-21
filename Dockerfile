FROM ubuntu:14.04
# MAINTAINER Fabio Rehm "fgrehm@gmail.com" modified by Reto Gmür

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
RUN echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list


RUN apt-get update && apt-get install -y firefox tilda subversion git retext mercurial tcpflow unzip sbt librxtx-java


RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev nodejs npm chromium-browser && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g browserify
RUN echo chromium-browser --no-sandbox > /usr/local/bin/chromium

ADD state.xml /tmp/state.xml

RUN wget http://dlc-cdn.sun.com/netbeans/8.0.2/final/bundles/netbeans-8.0.2-javaee-linux.sh -O /tmp/netbeans.sh -q && \
    chmod +x /tmp/netbeans.sh && \
    echo 'Installing netbeans' && \
    /tmp/netbeans.sh --silent --state /tmp/state.xml && \
    rm -rf /tmp/*


ADD run /usr/local/bin/netbeans

RUN chmod +x /usr/local/bin/netbeans && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer

ADD tilda-config /home/template/.config/tilda/config_0

RUN echo "Adding start script"

ADD start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

USER developer

ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/start.sh
