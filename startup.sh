docker run -ti --rm \
            -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v `pwd`/.m2:/home/developer/.m2 \
           -v `pwd`/.ivy2:/home/developer/.ivy2 \
           -v `pwd`/config:/home/developer/config  \
           -v `pwd`/projects:/home/developer/NetBeansProjects \
           reto/netbeans
