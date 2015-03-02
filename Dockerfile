FROM ubuntu:14.04
# MAINTAINER Fabio Rehm "fgrehm@gmail.com" modified by Reto Gmür

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN apt-get update && apt-get install -y firefox tilda git retext mercurial tcpflow


RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java7-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN wget -O /tmp/intellij.tar.gz http://download-cf.jetbrains.com/idea/ideaIC-14.0.3.tar.gz && \
tar xfz /tmp/intellij.tar.gz && \
cd idea-IC-139.1117.1/bin/ && \
sudo ln -s `pwd`/idea.sh /usr/local/bin/idea

RUN chmod +x /usr/local/bin/idea && \
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
