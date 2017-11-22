FROM reto/x11-xpra:5
MAINTAINER Reto Gmür "me@farewellutopia.com"
# based on docker-netbeans by Fabio Rehm "fgrehm@gmail.com"

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
RUN echo LC_ALL=en_US.UTF-8 >>  /etc/environment
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list

#force-yes needed because of missing certificate for sbt
RUN apt-get update && apt-get install -y --force-yes firefox tilda xfce4-terminal subversion iputils-ping git retext mercurial tcpflow unzip sbt ruby ruby-dev librxtx-java vim



RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common sudo && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev npm chromium-browser && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN npm cache clean -f && \
    npm install -g n && \
    n stable && \
    ln -sf /usr/local/n/versions/node/*/bin/node /usr/bin/node

#     rm -rf /tmp/* && \

RUN npm install -g browserify
RUN gem install jekyll
RUN echo chromium-browser --no-sandbox > /usr/local/bin/chromium && \
    chmod +rx /usr/local/bin/chromium

ADD state.xml /tmp/state.xml

RUN wget http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-javaee-linux.sh -O /tmp/netbeans.sh -q && \
    chmod +x /tmp/netbeans.sh && \
    echo 'Installing netbeans' && \
    /tmp/netbeans.sh --silent --state /tmp/state.xml && \
    rm -rf /tmp/* && \
    ln -s /usr/local/netbeans-8.2 /usr/local/netbeans

ADD run /usr/local/bin/netbeans

RUN chmod +rx /usr/local/bin/netbeans && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user 

ADD tilda-config /home/template/.config/tilda/config_0

RUN echo "Adding start script"

ADD start-dev-tools.sh /usr/local/bin/start-dev-tools

RUN chmod +rx /usr/local/bin/start-dev-tools
